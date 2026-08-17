package dao;

import util.DBConnection;
import model.ReservationView;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import dao.ReservationDAO;
import model.ReservationView;
import java.util.List;

public class ReservationDAO {

    public String generateReservationNo() {
        String date = LocalDate.now().toString().replace("-", "");
        return "RES-" + date + "-" + System.currentTimeMillis();
    }

    public double calculateTotal(double pricePerNight, LocalDate in, LocalDate out) {
        long nights = ChronoUnit.DAYS.between(in, out);
        if (nights < 1) nights = 1;
        return nights * pricePerNight;
    }

    public boolean createReservationAndBookRoom(
            String reservationNo,
            int userId,
            int roomId,
            LocalDate checkIn,
            LocalDate checkOut
    ) {

        String getPriceSql = "SELECT price FROM rooms WHERE id=?";
        String updateRoomSql = "UPDATE rooms SET status='BOOKED' WHERE id=? AND status='AVAILABLE'";
        String insertResSql =
                "INSERT INTO reservations(reservation_no, user_id, room_id, check_in, check_out, total_amount, status) " +
                "VALUES(?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // 1) Get room price
            double price;
            try (PreparedStatement psp = con.prepareStatement(getPriceSql)) {
                psp.setInt(1, roomId);
                try (ResultSet rs = psp.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    price = rs.getDouble("price");
                }
            }

            // 2) Book room only if AVAILABLE
            try (PreparedStatement ps1 = con.prepareStatement(updateRoomSql)) {
                ps1.setInt(1, roomId);
                int updated = ps1.executeUpdate();
                if (updated == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 3) Insert reservation row
            double total = calculateTotal(price, checkIn, checkOut);

            try (PreparedStatement ps2 = con.prepareStatement(insertResSql)) {
                ps2.setString(1, reservationNo);
                ps2.setInt(2, userId);
                ps2.setInt(3, roomId);
                ps2.setDate(4, java.sql.Date.valueOf(checkIn));
                ps2.setDate(5, java.sql.Date.valueOf(checkOut));
                ps2.setDouble(6, total);
                ps2.setString(7, "CONFIRMED");
                ps2.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ FOR ADMIN DASHBOARD (Recent Reservations)
    public List<ReservationView> findRecent(int limit) {
        List<ReservationView> list = new ArrayList<>();

        String sql =
            "SELECT r.reservation_no, u.full_name, rm.room_no, r.check_in, r.check_out, r.total_amount, r.status " +
            "FROM reservations r " +
            "JOIN users u ON u.id = r.user_id " +
            "JOIN rooms rm ON rm.id = r.room_id " +
            "ORDER BY r.id DESC " +
            "LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationView v = new ReservationView();
                    v.setReservationNo(rs.getString("reservation_no"));
                    v.setClientName(rs.getString("full_name"));
                    v.setRoomNo(rs.getString("room_no"));
                    v.setCheckIn(rs.getDate("check_in"));
                    v.setCheckOut(rs.getDate("check_out"));
                    v.setTotalAmount(rs.getDouble("total_amount"));
                    v.setStatus(rs.getString("status"));
                    list.add(v);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}