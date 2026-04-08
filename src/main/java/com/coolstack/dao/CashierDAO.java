package com.coolstack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.coolstack.util.DBConnection;

public class CashierDAO {
    public boolean addCashierProfile(int userId, String counterNumber) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO cashiers_details (user_id, counter_number) VALUES (?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, counterNumber);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
