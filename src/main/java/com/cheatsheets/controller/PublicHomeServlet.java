
package com.cheatsheets.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheets.config.DBConnect;
import com.cheatsheets.dao.CategoryDAO;
import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Snippet;
import com.cheatsheets.model.User;

@WebServlet("/explore")
public class PublicHomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        SnippetDAO sDao = new SnippetDAO();
        CategoryDAO cDao = new CategoryDAO(DBConnect.getConnection());
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int currentUserId = (user != null) ? user.getId() : 0;
        
        String searchQuery = request.getParameter("search");
        String catId = request.getParameter("category");
        String filter = request.getParameter("filter"); // 👈 ဒါလေး ထပ်ယူမယ်
        
        List<Snippet> list;

        // ၁။ Search လုပ်နေတာလား?
        if (searchQuery != null && !searchQuery.isEmpty()) {
            list = sDao.searchSnippets(searchQuery, currentUserId); 
        } 
        // ၂။ Category Filter သုံးနေတာလား?
        else if (catId != null && !catId.isEmpty()) {
            try {
                list = sDao.getSnippetsByCategory(Integer.parseInt(catId), currentUserId);
            } catch (NumberFormatException e) {
                list = sDao.getAllSnippets(currentUserId);
            }
        } 
        // ၃။ "Top Rated" Filter သုံးနေတာလား? 👈 ဒါက အခုထည့်မယ့် အပိုင်းပါ
        else if ("top".equals(filter)) {
            list = sDao.getTopRatedSnippets(currentUserId); 
        }
        // ၄။ ဘာမှမလုပ်ရင် အကုန်ပြမယ် (Default)
        else {
            list = sDao.getAllSnippets(currentUserId);
        }

        request.setAttribute("categories", cDao.getAllCategories());
        request.setAttribute("snippets", list); // ⚠️ "snippetList" မဟုတ်ဘဲ မူလအတိုင်း "snippets" လို့ပဲ သုံးပါ

        if (user != null && "admin".equalsIgnoreCase(user.getRole())) {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("public-index.jsp").forward(request, response);
        }
    }
}