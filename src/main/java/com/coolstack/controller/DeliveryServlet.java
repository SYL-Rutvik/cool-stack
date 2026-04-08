package com.coolstack.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.coolstack.util.DBConnection;

@WebServlet("/DeliveryServlet")
public class DeliveryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        try {
            int orderId = Integer.parseInt(orderIdStr);
            String sql = "";
            int cashierId = -1;

            if ("start".equals(action)) {
                sql = "UPDATE orders SET status = 'Out for Delivery' WHERE id = ?";
            } else if ("deliver".equals(action)) {
                sql = "UPDATE orders SET status = 'Delivered' WHERE id = ?";
            } else if ("deposit".equals(action)) {
                String cashierIdStr = request.getParameter("cashierId");
                cashierId = Integer.parseInt(cashierIdStr);
                sql = "UPDATE orders SET status = 'Paid', cashier_id = ? WHERE id = ?";
            }

            try (Connection conn = DBConnection.getConnection()) {
                if (conn == null) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Connection Failed");
                    return;
                }
                if (sql.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Action");
                    return;
                }

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    if ("deposit".equals(action)) {
                        ps.setInt(1, cashierId);
                        ps.setInt(2, orderId);
                    } else {
                        ps.setInt(1, orderId);
                    }
                    
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("Success");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order #" + orderId + " not found or status already updated");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Order ID or Cashier ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server Error: " + e.getMessage());
        }
    }
}
