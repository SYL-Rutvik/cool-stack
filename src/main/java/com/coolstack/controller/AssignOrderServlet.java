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

@WebServlet("/AssignOrderServlet")
public class AssignOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String deliveryBoyIdStr = request.getParameter("deliveryBoyId");

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int deliveryBoyId = Integer.parseInt(deliveryBoyIdStr);

            try (Connection conn = DBConnection.getConnection()) {
                if (conn != null) {
                    String sql = "UPDATE orders SET status = 'Processing', delivery_boy_id = ? WHERE id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, deliveryBoyId);
                    ps.setInt(2, orderId);
                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("Success");
                    } else {
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Order Not Found");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Parameters");
        }
    }
}
