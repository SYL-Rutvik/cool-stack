package com.coolstack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.coolstack.model.Customer;
import com.coolstack.util.DBConnection;

public class CustomerDAO {
    
    public Customer getCustomerById(int id) {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM customers WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    customer = new Customer();
                    customer.setId(rs.getInt("id"));
                    customer.setName(rs.getString("name"));
                    customer.setShopName(rs.getString("shop_name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setAddress(rs.getString("address"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }

    public boolean addCustomerProfile(int userId, String name, String shopName, String email, String phone, String address) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                // Insert into customers_details table (underlying table for customers view)
                String sql = "INSERT INTO customers_details (user_id, shop_name, address) VALUES (?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, shopName);
                ps.setString(3, address);
                
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCustomer(Customer customer) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "UPDATE customers SET name=?, shop_name=?, email=?, phone=?, address=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, customer.getName());
                ps.setString(2, customer.getShopName());
                ps.setString(3, customer.getEmail());
                ps.setString(4, customer.getPhone());
                ps.setString(5, customer.getAddress());
                ps.setInt(6, customer.getId());
                
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
