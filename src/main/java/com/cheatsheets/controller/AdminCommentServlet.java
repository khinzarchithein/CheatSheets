package com.cheatsheets.controller;

import com.cheatsheets.dao.CommentDAO;
import com.cheatsheets.model.Comment;
import com.cheatsheets.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin-comments")
public class AdminCommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    // GET: Admin အတွက် Comment List စာမျက်နှာကို ပြသရန်
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Admin ဟုတ်မဟုတ် လုံခြုံရေး စစ်ဆေးခြင်း
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Comment> allComments = commentDAO.getAllCommentsForAdmin();
        request.setAttribute("adminComments", allComments);
        request.getRequestDispatcher("admin-comments.jsp").forward(request, response);
    }

    // POST: Admin က Delete ခလုတ်နှိပ်လျှင် လာရောက်အလုပ်လုပ်မည့်နေရာ
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.getWriter().print("unauthorized");
            return;
        }

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        boolean success = commentDAO.deleteCommentByAdmin(commentId);

        if (success) {
            response.getWriter().print("success");
        } else {
            response.getWriter().print("error");
        }
    }
}