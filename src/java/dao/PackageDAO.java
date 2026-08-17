package dao;

import model.Package;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class PackageDAO {

    public List<Package> findAll() {
        List<Package> list = new ArrayList<>();
        String sql = "SELECT * FROM packages ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Package p = new Package();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPricePerNight(rs.getDouble("price_per_night"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insert(Package p) {
        String sql = "INSERT INTO packages(name, description, price_per_night, status) VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPricePerNight());
            ps.setString(4, p.getStatus());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ keep only one update()
    public boolean update(Package p) {
        String sql = "UPDATE packages SET name=?, description=?, price_per_night=?, status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPricePerNight());
            ps.setString(4, p.getStatus());
            ps.setInt(5, p.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

   public boolean delete(int id) {
    String sql = "DELETE FROM packages WHERE id=?";
    try (java.sql.Connection con = util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}