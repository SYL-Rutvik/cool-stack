package com.coolstack.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.coolstack.dao.ManagerDAO;
import com.coolstack.model.Manager;

@WebServlet("/ManagerProfileServlet")
public class ManagerProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        int id = (session != null && session.getAttribute("loggedUserId") != null) ? (int) session.getAttribute("loggedUserId") : 1;
        
        ManagerDAO dao = new ManagerDAO();
        Manager manager = dao.getManagerById(id);

        if (manager == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First");
            return;
        }

        request.setAttribute("manager", manager);
        request.getRequestDispatcher("/employee/manager/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Manager manager = new Manager();
        manager.setId(id);
        manager.setName(name);
        manager.setEmail(email);
        manager.setPhone(phone);

        ManagerDAO dao = new ManagerDAO();
        boolean success = dao.updateManager(manager);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ManagerProfileServlet?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/ManagerProfileServlet?status=error");
        }
    }
}
