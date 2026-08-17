package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    public int countRooms() {
        return countInt("SELECT COUNT(*) FROM rooms");
    }

    public int countAvailableRooms() {
        return countInt("SELECT COUNT(*) FROM rooms WHERE status='AVAILABLE'");
    }

    public int countBookedRooms() {
        return countInt("SELECT COUNT(*) FROM rooms WHERE status='BOOKED'");
    }

    public int countReservations() {
        return countInt("SELECT COUNT(*) FROM reservations");
    }

    private int countInt(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Recent reservations (latest 8)
    public List<String[]> recentReservations() {
        List<String[]> list = new ArrayList<>();

        String sql =
                "SELECT r.reservation_no, u.username, rm.room_no, r.check_in, r.check_out, r.total, rm.status " +
                "FROM reservations r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN rooms rm ON r.room_id = rm.id " +
                "ORDER BY r.id DESC " +
                "LIMIT 8";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new String[]{
                        rs.getString("reservation_no"),
                        rs.getString("username"),
                        rs.getString("room_no"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getString("total"),
                        rs.getString("status")
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}