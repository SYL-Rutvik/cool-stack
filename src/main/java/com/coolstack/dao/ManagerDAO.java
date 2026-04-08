package com.coolstack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.coolstack.model.Manager;
import com.coolstack.util.DBConnection;

public class ManagerDAO {
    
    public Manager getManagerById(int id) {
        Manager manager = null;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM managers WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    manager = new Manager();
                    manager.setId(rs.getInt("id"));
                    manager.setName(rs.getString("name"));
                    manager.setEmail(rs.getString("email"));
                    manager.setPhone(rs.getString("phone"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return manager;
    }

    public boolean addManagerProfile(int userId, String name, String email, String phone) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                // Insert into managers_details table (underlying table for managers view)
                String sql = "INSERT INTO managers_details (user_id) VALUES (?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateManager(Manager manager) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "UPDATE managers SET name=?, email=?, phone=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, manager.getName());
                ps.setString(2, manager.getEmail());
                ps.setString(3, manager.getPhone());
                ps.setInt(4, manager.getId());
                
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
