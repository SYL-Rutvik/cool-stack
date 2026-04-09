package com.coolstack.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.coolstack.util.DBConnection;

/**
 * Handles all product CRUD + restock operations for the Manager Inventory panel.
 * Actions: add, edit, delete, restock
 * Responds with JSON: { "success": true/false, "message": "...", "newStock": N }
 */
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if (action == null) {
            out.print("{\"success\":false,\"message\":\"No action specified\"}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                out.print("{\"success\":false,\"message\":\"Database connection failed\"}");
                return;
            }

            Integer userId = (Integer) request.getSession().getAttribute("loggedUserId");
            if (userId == null) userId = 1; // Fallback to System Admin if session lost

            switch (action) {

                // ── ADD NEW PRODUCT ─────────────────────────────────────────────
                case "add": {
                    String name     = request.getParameter("name");
                    String category = request.getParameter("category");
                    String flavor   = request.getParameter("flavor");
                    String priceStr = request.getParameter("price");
                    String stockStr = request.getParameter("stock");
                    String pbsStr   = request.getParameter("pieces_per_box");

                    if (name == null || name.trim().isEmpty() || priceStr == null || stockStr == null) {
                        out.print("{\"success\":false,\"message\":\"Required fields missing\"}");
                        return;
                    }

                    // Check duplicate name
                    PreparedStatement checkPs = conn.prepareStatement("SELECT id FROM products WHERE LOWER(name)=LOWER(?)");
                    checkPs.setString(1, name.trim());
                    ResultSet checkRs = checkPs.executeQuery();
                    if (checkRs.next()) {
                        out.print("{\"success\":false,\"message\":\"Product name already exists. Use Restock instead.\"}");
                        checkPs.close();
                        return;
                    }
                    checkPs.close();

                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO products (name, category, flavor, price, stock_quantity, pieces_per_box) VALUES (?,?,?,?,?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
                    ps.setString(1, name.trim());
                    ps.setString(2, category != null ? category.trim() : "General");
                    ps.setString(3, flavor != null ? flavor.trim() : "");
                    ps.setBigDecimal(4, new BigDecimal(priceStr));
                    ps.setInt(5, Integer.parseInt(stockStr));
                    ps.setInt(6, pbsStr != null && !pbsStr.isEmpty() ? Integer.parseInt(pbsStr) : 0);
                    int rows = ps.executeUpdate();
                    
                    if (rows > 0) {
                        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                int newProductId = generatedKeys.getInt(1);
                                try (PreparedStatement logPs = conn.prepareStatement(
                                    "INSERT INTO inventory_logs (product_id, user_id, action_type, quantity_change, new_stock) VALUES (?, ?, 'Add Product', ?, ?)")) {
                                    logPs.setInt(1, newProductId);
                                    logPs.setInt(2, userId);
                                    logPs.setInt(3, Integer.parseInt(stockStr));
                                    logPs.setInt(4, Integer.parseInt(stockStr));
                                    logPs.executeUpdate();
                                }
                            }
                        }
                    }
                    ps.close();

                    out.print(rows > 0
                        ? "{\"success\":true,\"message\":\"Product added successfully\"}"
                        : "{\"success\":false,\"message\":\"Failed to add product\"}");
                    break;
                }

                // ── EDIT EXISTING PRODUCT ───────────────────────────────────────
                case "edit": {
                    String idStr    = request.getParameter("id");
                    String name     = request.getParameter("name");
                    String category = request.getParameter("category");
                    String flavor   = request.getParameter("flavor");
                    String priceStr = request.getParameter("price");
                    String pbsStr   = request.getParameter("pieces_per_box");

                    if (idStr == null || name == null || priceStr == null) {
                        out.print("{\"success\":false,\"message\":\"Required fields missing\"}");
                        return;
                    }

                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE products SET name=?, category=?, flavor=?, price=?, pieces_per_box=? WHERE id=?");
                    ps.setString(1, name.trim());
                    ps.setString(2, category != null ? category.trim() : "General");
                    ps.setString(3, flavor != null ? flavor.trim() : "");
                    ps.setBigDecimal(4, new BigDecimal(priceStr));
                    ps.setInt(5, pbsStr != null && !pbsStr.isEmpty() ? Integer.parseInt(pbsStr) : 0);
                    ps.setInt(6, Integer.parseInt(idStr));
                    int rows = ps.executeUpdate();
                    ps.close();

                    if (rows > 0) {
                        try (PreparedStatement logPs = conn.prepareStatement(
                            "INSERT INTO inventory_logs (product_id, user_id, action_type) VALUES (?, ?, 'Edit Product')")) {
                            logPs.setInt(1, Integer.parseInt(idStr));
                            logPs.setInt(2, userId);
                            logPs.executeUpdate();
                        }
                    }

                    out.print(rows > 0
                        ? "{\"success\":true,\"message\":\"Product updated\"}"
                        : "{\"success\":false,\"message\":\"No product found with that ID\"}");
                    break;
                }

                // ── DELETE PRODUCT ──────────────────────────────────────────────
                case "delete": {
                    String idStr = request.getParameter("id");
                    if (idStr == null) {
                        out.print("{\"success\":false,\"message\":\"ID required\"}");
                        return;
                    }
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id=?");
                    ps.setInt(1, Integer.parseInt(idStr));
                    int rows = ps.executeUpdate();
                    ps.close();

                    out.print(rows > 0
                        ? "{\"success\":true,\"message\":\"Product deleted\"}"
                        : "{\"success\":false,\"message\":\"Product not found\"}");
                    break;
                }

                case "restock": {
                    String idStr    = request.getParameter("id");
                    String addStr   = request.getParameter("addQty");
                    if (idStr == null || addStr == null || addStr.trim().isEmpty()) {
                        out.print("{\"success\":false,\"message\":\"ID and addQty required\"}");
                        return;
                    }
                    int addQty = Integer.parseInt(addStr);
                    if (addQty == 0) {
                        out.print("{\"success\":false,\"message\":\"Quantity cannot be zero\"}");
                        return;
                    }

                    int prodId = Integer.parseInt(idStr);
                    int priorStock = 0;
                    try (PreparedStatement chk = conn.prepareStatement("SELECT stock_quantity FROM products WHERE id=?")) {
                        chk.setInt(1, prodId);
                        ResultSet rs = chk.executeQuery();
                        if (rs.next()) priorStock = rs.getInt("stock_quantity");
                    }

                    if (priorStock + addQty < 0) {
                        out.print("{\"success\":false,\"message\":\"Cannot reduce stock below 0. Current stock is " + priorStock + ".\"}");
                        return;
                    }

                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE products SET stock_quantity = stock_quantity + ? WHERE id=?");
                    ps.setInt(1, addQty);
                    ps.setInt(2, prodId);
                    int rows = ps.executeUpdate();
                    ps.close();

                    if (rows > 0) {
                        int newStock = priorStock + addQty;
                        try (PreparedStatement logPs = conn.prepareStatement(
                            "INSERT INTO inventory_logs (product_id, user_id, action_type, quantity_change, prior_stock, new_stock) VALUES (?, ?, 'Restock', ?, ?, ?)")) {
                            logPs.setInt(1, prodId);
                            logPs.setInt(2, userId);
                            logPs.setInt(3, addQty);
                            logPs.setInt(4, priorStock);
                            logPs.setInt(5, newStock);
                            logPs.executeUpdate();
                        }
                        out.print("{\"success\":true,\"message\":\"Stock updated\",\"newStock\":" + newStock + "}");
                    } else {
                        out.print("{\"success\":false,\"message\":\"Product not found\"}");
                    }
                    break;
                }

                // ── BULK DELETE ────────────────────────────────────────────────
                case "bulk_delete": {
                    String[] ids = request.getParameterValues("ids[]");
                    if (ids == null || ids.length == 0) {
                        out.print("{\"success\":false,\"message\":\"No selected items\"}");
                        return;
                    }
                    conn.setAutoCommit(false);
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id = ?")) {
                        for (String id : ids) {
                            ps.setInt(1, Integer.parseInt(id));
                            ps.addBatch();
                        }
                        ps.executeBatch();
                        conn.commit();
                        out.print("{\"success\":true,\"message\":\"Items deleted successfully\"}");
                    } catch (Exception e) {
                        conn.rollback();
                        throw e;
                    } finally {
                        conn.setAutoCommit(true);
                    }
                    break;
                }

                // ── FETCH LOGS ──────────────────────────────────────────────────
                case "fetch_logs": {
                    String sql = "SELECT l.*, p.name as product_name, u.name as user_name FROM inventory_logs l " +
                                 "JOIN products p ON l.product_id = p.id " +
                                 "JOIN users u ON l.user_id = u.id " +
                                 "ORDER BY l.log_date DESC LIMIT 50";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    
                    StringBuilder json = new StringBuilder("[");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) json.append(",");
                        json.append("{");
                        json.append("\"date\":\"").append(rs.getTimestamp("log_date").toString()).append("\",");
                        json.append("\"user\":\"").append(rs.getString("user_name").replace("\"", "\\\"")).append("\",");
                        json.append("\"product\":\"").append(rs.getString("product_name").replace("\"", "\\\"")).append("\",");
                        json.append("\"action\":\"").append(rs.getString("action_type")).append("\",");
                        json.append("\"change\":").append(rs.getInt("quantity_change")).append(",");
                        json.append("\"new_stock\":").append(rs.getInt("new_stock"));
                        json.append("}");
                        first = false;
                    }
                    json.append("]");
                    rs.close();
                    ps.close();
                    out.print("{\"success\":true,\"logs\":" + json.toString() + "}");
                    break;
                }


                default:
                    out.print("{\"success\":false,\"message\":\"Unknown action: " + action + "\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Server error: " + e.getMessage().replace("\"","'") + "\"}");
        }
    }
}
