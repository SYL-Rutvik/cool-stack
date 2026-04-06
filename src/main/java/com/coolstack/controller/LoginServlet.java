package com.coolstack.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.coolstack.dao.AuthDAO;
import com.coolstack.model.User;

/**
 * Manages centralized login operations.
 * Authenticates users against the unified 'users' table and redirects to role-based portals.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Use the centralized AuthDAO
        AuthDAO authDAO = new AuthDAO();
        User authenticatedUser = authDAO.authenticateUser(username, password);

        if (authenticatedUser != null) {
            String dbRole = authenticatedUser.getRole();
            
            // Success: Establish secure session keeping user data available across JSPs
            HttpSession session = request.getSession();
            session.setAttribute("loggedUserId", authenticatedUser.getId());
            session.setAttribute("loggedUserRole", dbRole);
            session.setAttribute("loggedUsername", authenticatedUser.getUsername());
            session.setAttribute("loggedFullName", authenticatedUser.getName());

            // Redirect based on the authenticated role from the database
            switch (dbRole) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                    break;
                case "manager":
                    response.sendRedirect(request.getContextPath() + "/employee/manager/dashboard.jsp");
                    break;
                case "delivery":
                    response.sendRedirect(request.getContextPath() + "/employee/delivery/dashboard.jsp");
                    break;
                case "cashier":
                    response.sendRedirect(request.getContextPath() + "/employee/cashier/dashboard.jsp");
                    break;
                case "customer":
                    response.sendRedirect(request.getContextPath() + "/customer/place_order.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid Route Mapping for: " + dbRole);
            }
        } else {
            // Failure: Reject credentials
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid Username or Password!");
        }
    }
}
