package dao;

import model.ReservationView;
import service.BillingService;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public static class RoomInfo {
        public int id;
        public String roomNo;
        public String roomType;
        public double price;
        public String status;
    }

    private final BillingService billingService = new BillingService();

    public String generateReservationNo() {
        String date = LocalDate.now().toString().replace("-", "");
        return "RES-" + date + "-" + System.currentTimeMillis();
    }

    public double calculateTotal(double pricePerNight, LocalDate in, LocalDate out) {
        return billingService.calculateRoomTotal(pricePerNight, in, out);
    }

    public RoomInfo getRoomInfo(int roomId) {
        String sql = "SELECT id, room_no, room_type, price, status FROM rooms WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                RoomInfo info = new RoomInfo();
                info.id = rs.getInt("id");
                info.roomNo = rs.getString("room_no");
                info.roomType = rs.getString("room_type");
                info.price = rs.getDouble("price");
                info.status = rs.getString("status");
                return info;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }
            con.setAutoCommit(false);

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

            try (PreparedStatement ps1 = con.prepareStatement(updateRoomSql)) {
                ps1.setInt(1, roomId);
                int updated = ps1.executeUpdate();
                if (updated == 0) {
                    con.rollback();
                    return false;
                }
            }

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
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ignored) {
            }
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    public List<ReservationView> findRecent(int limit) {
        String sql = baseSelect() + " ORDER BY r.id DESC LIMIT ?";
        List<ReservationView> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ReservationView findByReservationNo(String reservationNo) {
        String sql = baseSelect() + " WHERE r.reservation_no = ? LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, reservationNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ReservationView> findByUserId(int userId) {
        String sql = baseSelect() + " WHERE r.user_id = ? ORDER BY r.id DESC";
        List<ReservationView> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double sumConfirmedRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM reservations WHERE status='CONFIRMED'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String baseSelect() {
        return "SELECT r.id, r.reservation_no, r.user_id, u.full_name, u.phone, u.address, u.username, " +
                "rm.room_no, rm.room_type, rm.price, r.check_in, r.check_out, r.total_amount, r.status " +
                "FROM reservations r " +
                "JOIN users u ON u.id = r.user_id " +
                "JOIN rooms rm ON rm.id = r.room_id";
    }

    private ReservationView map(ResultSet rs) throws Exception {
        ReservationView v = new ReservationView();
        v.setId(rs.getInt("id"));
        v.setReservationNo(rs.getString("reservation_no"));
        v.setUserId(rs.getInt("user_id"));
        v.setClientName(rs.getString("full_name"));
        v.setClientPhone(rs.getString("phone"));
        v.setClientAddress(rs.getString("address"));
        v.setClientUsername(rs.getString("username"));
        v.setRoomNo(rs.getString("room_no"));
        v.setRoomType(rs.getString("room_type"));
        v.setPricePerNight(rs.getDouble("price"));
        v.setCheckIn(rs.getDate("check_in"));
        v.setCheckOut(rs.getDate("check_out"));
        v.setTotalAmount(rs.getDouble("total_amount"));
        v.setStatus(rs.getString("status"));
        return v;
    }
}
