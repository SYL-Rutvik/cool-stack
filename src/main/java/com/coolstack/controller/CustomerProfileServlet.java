package com.coolstack.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.coolstack.dao.CustomerDAO;
import com.coolstack.model.Customer;

@WebServlet("/CustomerProfileServlet")
public class CustomerProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        int id = (session != null && session.getAttribute("loggedUserId") != null) ? (int) session.getAttribute("loggedUserId") : 1;
        
        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerById(id);

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First");
            return;
        }

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String shopName = request.getParameter("shopName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        Customer customer = new Customer();
        customer.setId(id);
        customer.setName(name);
        customer.setShopName(shopName);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setAddress(address);

        CustomerDAO dao = new CustomerDAO();
        boolean success = dao.updateCustomer(customer);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/CustomerProfileServlet?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/CustomerProfileServlet?status=error");
        }
    }
}
