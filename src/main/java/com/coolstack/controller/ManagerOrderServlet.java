package com.coolstack.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.coolstack.util.DBConnection;

@WebServlet("/ManagerOrderServlet")
public class ManagerOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> resMap = new HashMap<>();

        if ("getDetails".equals(action)) {
            String orderIdStr = request.getParameter("id");
            try {
                int orderId = Integer.parseInt(orderIdStr);
                try (Connection conn = DBConnection.getConnection()) {
                    List<Map<String, Object>> items = new ArrayList<>();
                    // Get items
                    String sql = "SELECT oi.quantity, oi.unit_price, oi.subtotal, p.name " +
                                 "FROM order_items oi JOIN products p ON oi.product_id = p.id " +
                                 "WHERE oi.order_id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, orderId);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", rs.getString("name"));
                        item.put("quantity", rs.getInt("quantity"));
                        item.put("unit_price", rs.getBigDecimal("unit_price"));
                        item.put("subtotal", rs.getBigDecimal("subtotal"));
                        items.add(item);
                    }
                    resMap.put("success", true);
                    resMap.put("items", items);
                }
            } catch (Exception e) {
                e.printStackTrace();
                resMap.put("success", false);
                resMap.put("message", "Error loading details.");
            }
        } else {
            resMap.put("success", false);
            resMap.put("message", "Invalid action.");
        }
        out.print(gson.toJson(resMap));
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> resMap = new HashMap<>();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "DELETE FROM orders WHERE id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, id);
                    if (ps.executeUpdate() > 0) {
                        resMap.put("success", true);
                    } else {
                        resMap.put("success", false);
                        resMap.put("message", "Order not found");
                    }
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                String dboyInfo = request.getParameter("deliveryBoyId"); // Can be empty or numeric

                try (Connection conn = DBConnection.getConnection()) {
                    if (dboyInfo != null && !dboyInfo.trim().isEmpty()) {
                        String sql = "UPDATE orders SET status = ?, delivery_boy_id = ? WHERE id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setString(1, status);
                        ps.setInt(2, Integer.parseInt(dboyInfo));
                        ps.setInt(3, id);
                        ps.executeUpdate();
                    } else {
                        String sql = "UPDATE orders SET status = ?, delivery_boy_id = NULL WHERE id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setString(1, status);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                    }
                    resMap.put("success", true);
                }
            } else {
                resMap.put("success", false);
                resMap.put("message", "Invalid POST action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resMap.put("success", false);
            resMap.put("message", "Database error occurred.");
        }
        out.print(gson.toJson(resMap));
        out.flush();
    }
}
