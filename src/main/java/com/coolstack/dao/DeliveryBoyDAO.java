package com.coolstack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.coolstack.util.DBConnection;

public class DeliveryBoyDAO {
    public boolean addDeliveryBoyProfile(int userId, String vehicleNumber) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO delivery_boys_details (user_id, vehicle_number) VALUES (?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, vehicleNumber);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
