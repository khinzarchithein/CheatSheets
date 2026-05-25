package com.cheatsheets.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheets.dao.UserDAO;
import com.cheatsheets.model.User;

/**
 * Servlet implementation class SignUpServlet
 */
@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // Simple Validation
        if (name == null || email == null || pass.length() < 6) {
            request.getSession().setAttribute("errorMsg", "Password must be at least 6 characters!");
            response.sendRedirect("signup.jsp");
            return;
        }

        User user = new User();
        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(pass);

        UserDAO uDao = new UserDAO();
        if (uDao.registerUser(user)) {
            response.sendRedirect("login.jsp?success=registered");
        } else {
            request.getSession().setAttribute("errorMsg", "Email already exists!");
            response.sendRedirect("signup.jsp");
        }
    }
}