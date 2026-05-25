
package com.cheatsheets.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Snippet;
import com.cheatsheets.model.User;

@WebServlet("/saved-list")
public class SavedListServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // ၁။ Login မဝင်ထားရင် Login Page ကို လွှတ်မယ်
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ၂။ DAO ကနေ ဒီ User သိမ်းထားတဲ့ Snippet တွေပဲ ဆွဲထုတ်မယ်
        SnippetDAO dao = new SnippetDAO();
        // getSavedSnippetsByUser ဆိုတဲ့ method ကို DAO မှာ ထပ်တိုးရပါမယ် (အောက်မှာ ပါပါတယ်)
        List<Snippet> savedList = dao.getSavedSnippetsByUser(user.getId());

        request.setAttribute("snippets", savedList);
        
        // ၃။ Saved Page ကို ပို့မယ်
        request.getRequestDispatcher("saved-snippets.jsp").forward(request, response);
    }
}