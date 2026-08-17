package dao;

import model.Room;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class RoomDAO {

    // =========================
    // GET ALL ROOMS
    // =========================
    public List<Room> findAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("id"));
                r.setRoomNo(rs.getString("room_no"));
                r.setRoomType(rs.getString("room_type"));
                r.setPrice(rs.getDouble("price"));
                r.setStatus(rs.getString("status"));
                r.setPackageId(rs.getInt("package_id"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // INSERT ROOM
    // =========================
    public boolean insert(Room r) {

        String sql = "INSERT INTO rooms(room_no, room_type, price, status, package_id) VALUES(?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getRoomNo());
            ps.setString(2, r.getRoomType());
            ps.setDouble(3, r.getPrice());
            ps.setString(4, r.getStatus());
            ps.setInt(5, r.getPackageId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // UPDATE ROOM
    // =========================
    public boolean update(Room r) {

        String sql = "UPDATE rooms SET room_no=?, room_type=?, price=?, status=?, package_id=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getRoomNo());
            ps.setString(2, r.getRoomType());
            ps.setDouble(3, r.getPrice());
            ps.setString(4, r.getStatus());
            ps.setInt(5, r.getPackageId());
            ps.setInt(6, r.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // DELETE ROOM
    // =========================
    public boolean delete(int id) {

        String sql = "DELETE FROM rooms WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Room> findAvailableRooms() {
    List<Room> list = new ArrayList<>();
    String sql = "SELECT * FROM rooms WHERE status='AVAILABLE' ORDER BY room_no ASC";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Room r = new Room();
            r.setId(rs.getInt("id"));
            r.setRoomNo(rs.getString("room_no"));
            r.setRoomType(rs.getString("room_type"));
            r.setPrice(rs.getDouble("price"));
            r.setStatus(rs.getString("status"));
            r.setPackageId(rs.getInt("package_id"));
            list.add(r);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}
}