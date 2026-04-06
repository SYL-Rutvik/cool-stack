package com.coolstack.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.coolstack.dao.AdminDAO;
import com.coolstack.model.Admin;

@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        int id = (session != null && session.getAttribute("loggedUserId") != null) ? (int) session.getAttribute("loggedUserId") : 1;
        
        AdminDAO dao = new AdminDAO();
        Admin admin = dao.getAdminById(id);

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First");
            return;
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Admin admin = new Admin();
        admin.setId(id);
        admin.setName(name);
        admin.setEmail(email);
        admin.setPhone(phone);

        AdminDAO dao = new AdminDAO();
        boolean success = dao.updateAdmin(admin);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminProfileServlet?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminProfileServlet?status=error");
        }
    }
}
