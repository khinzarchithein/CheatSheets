package com.cheatsheets.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class RatingServlet
 */
@WebServlet("/rate-snippet")
public class RatingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        com.cheatsheets.model.User user = (com.cheatsheets.model.User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("login_required");
            return;
        }

        try {
            int snippetId = Integer.parseInt(request.getParameter("snippetId"));
            int ratingValue = Integer.parseInt(request.getParameter("rating"));

            com.cheatsheets.dao.RatingDAO ratingDAO = new com.cheatsheets.dao.RatingDAO();
            boolean success = ratingDAO.addOrUpdateRating(snippetId, user.getId(), ratingValue);

            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}