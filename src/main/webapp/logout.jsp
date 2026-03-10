<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // This clears the session and routes the user back to the login page
    session.invalidate(); 
    response.sendRedirect("login.jsp"); 
%>