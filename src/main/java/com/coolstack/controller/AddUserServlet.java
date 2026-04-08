package com.coolstack.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.coolstack.dao.UserDAO;
import com.coolstack.dao.CustomerDAO;
import com.coolstack.dao.ManagerDAO;
import com.coolstack.dao.CashierDAO;
import com.coolstack.dao.DeliveryBoyDAO;
import com.coolstack.model.User;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private ManagerDAO managerDAO = new ManagerDAO();
    private CashierDAO cashierDAO = new CashierDAO();
    private DeliveryBoyDAO deliveryBoyDAO = new DeliveryBoyDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        boolean success = false;
        String message = "";
        
        if ("addCustomer".equals(action)) {
            String shopName = request.getParameter("shopName");
            String ownerName = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            User user = new User();
            user.setName(ownerName);
            user.setUsername(email); // Use email as username if not provided separately
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole("customer");
            
            int userId = userDAO.addUser(user);
            if (userId > 0) {
                success = customerDAO.addCustomerProfile(userId, ownerName, shopName, email, phone, address);
            }
            message = success ? "Customer added successfully" : "Failed to add customer";
            
        } else if ("addEmployee".equals(action)) {
            String name = request.getParameter("name");
            String role = request.getParameter("role").toLowerCase();
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            User user = new User();
            user.setName(name);
            user.setUsername(email);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole(role);
            
            int userId = userDAO.addUser(user);
            if (userId > 0) {
                if ("manager".equals(role)) {
                    success = managerDAO.addManagerProfile(userId, name, email, phone);
                } else if ("cashier".equals(role)) {
                    success = cashierDAO.addCashierProfile(userId, "N/A"); // Default or from request if added to modal
                } else if ("delivery".equals(role)) {
                    success = deliveryBoyDAO.addDeliveryBoyProfile(userId, "N/A"); // Default or from request if added to modal
                } else {
                    success = true; // Other roles might not have details
                }
            }
            message = success ? "Employee added successfully" : "Failed to add employee";
        }
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ", \"message\":\"" + message + "\"}");
        out.flush();
    }
}
