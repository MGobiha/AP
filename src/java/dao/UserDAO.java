package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.*;
import java.sql.*;
import model.Users;
import util.DBConnection;

public class UserDAO {

    // Register client
    public boolean registerClient(String fullName, String phone, String address,
                                  String username, String password, String role) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users(full_name, phone, address, username, password, role) VALUES(?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, username);
            ps.setString(5, password);
            ps.setString(6, role);

            int row = ps.executeUpdate();

            if (row > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Update profile
    public boolean updateProfile(int userId, String fullName, String phone, String address) {

        String sql = "UPDATE users SET full_name=?, phone=?, address=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setInt(4, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // FIND USERS BY ROLE (ADMIN / STAFF / CLIENT)
   // ADMIN: create staff (or admin)
public boolean insertUser(String fullName, String phone, String address,
                          String username, String password, String role) {
    String sql = "INSERT INTO users(full_name, phone, address, username, password, role) VALUES(?,?,?,?,?,?)";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, fullName);
        ps.setString(2, phone);
        ps.setString(3, address);
        ps.setString(4, username);
        ps.setString(5, password);
        ps.setString(6, role);

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

// LIST by role
public List<Users> findByRole(String role) {
    List<Users> list = new ArrayList<>();
    String sql = "SELECT * FROM users WHERE role=? ORDER BY id DESC";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, role);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users u = new Users();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// ADMIN: update staff fields (NOT password here)
public boolean updateUser(int id, String fullName, String phone, String address, String username) {
    String sql = "UPDATE users SET full_name=?, phone=?, address=?, username=? WHERE id=?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, fullName);
        ps.setString(2, phone);
        ps.setString(3, address);
        ps.setString(4, username);
        ps.setInt(5, id);

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

// ADMIN: delete user
public boolean deleteUser(int id) {
    String sql = "DELETE FROM users WHERE id=?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
public boolean updateUserWithRole(int id, String fullName, String phone, String address, String username, String role) {
    String sql = "UPDATE users SET full_name=?, phone=?, address=?, username=?, role=? WHERE id=?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, fullName);
        ps.setString(2, phone);
        ps.setString(3, address);
        ps.setString(4, username);
        ps.setString(5, role);
        ps.setInt(6, id);

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
   
    // get CLIENT + VIP_CLIENT together
public List<Users> findClients() {
    List<Users> list = new ArrayList<>();
    String sql = "SELECT * FROM users WHERE role IN ('CLIENT','VIP_CLIENT') ORDER BY id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Users u = new Users();
            u.setId(rs.getInt("id"));
            u.setFullName(rs.getString("full_name"));
            u.setPhone(rs.getString("phone"));
            u.setAddress(rs.getString("address"));
            u.setUsername(rs.getString("username"));
            u.setRole(rs.getString("role"));
            list.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public List<Users> findStaff() {
    List<Users> list = new ArrayList<>();
    String sql = "SELECT * FROM users WHERE role IN ('STAFF_L1','STAFF_L2','STAFF_L3') ORDER BY id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Users u = new Users();
            u.setId(rs.getInt("id"));
            u.setFullName(rs.getString("full_name"));
            u.setPhone(rs.getString("phone"));
            u.setAddress(rs.getString("address"));
            u.setUsername(rs.getString("username"));
            u.setRole(rs.getString("role"));
            list.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public boolean updateRole(int id, String role) {
    String sql = "UPDATE users SET role=? WHERE id=?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, role);
        ps.setInt(2, id);
        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

public Users login(String username, String password) {

    Users user = null;

    String sql = "SELECT * FROM users WHERE username=? AND password=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, username);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            user = new Users();
            user.setId(rs.getInt("id"));
            user.setFullName(rs.getString("full_name"));
            user.setUsername(rs.getString("username"));
            user.setRole(rs.getString("role"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return user;
}

}