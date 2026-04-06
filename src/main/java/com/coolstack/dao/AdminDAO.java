package com.coolstack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.coolstack.model.Admin;
import com.coolstack.util.DBConnection;

public class AdminDAO {
    public Admin getAdminById(int id) {
        Admin admin = null;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                // Use the view or the users table directly
                String sql = "SELECT * FROM users WHERE id = ? AND role = 'admin'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setName(rs.getString("name"));
                    admin.setUsername(rs.getString("username"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setProfilePhoto(rs.getString("profile_photo"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public boolean updateAdmin(Admin admin) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "UPDATE users SET name=?, email=?, phone=? WHERE id=? AND role='admin'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, admin.getName());
                ps.setString(2, admin.getEmail());
                ps.setString(3, admin.getPhone());
                ps.setInt(4, admin.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
