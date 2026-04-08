package com.coolstack.dao;

import java.sql.*;
import com.coolstack.model.User;
import com.coolstack.util.DBConnection;

public class UserDAO {
    
    public int addUser(User user) {
        int generatedId = -1;
        String sql = "INSERT INTO users (name, username, email, phone, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, user.getName());
                ps.setString(2, user.getUsername());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPhone());
                ps.setString(5, user.getPassword());
                ps.setString(6, user.getRole());
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }
}
