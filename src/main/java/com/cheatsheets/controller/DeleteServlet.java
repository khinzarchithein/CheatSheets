package com.cheatsheets.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Snippet;

/**
 * Servlet implementation class DeleteServlet
 */
@WebServlet("/delete-snippet")
public class DeleteServlet extends HttpServlet {
    private SnippetDAO snippetDAO = new SnippetDAO();

//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        
//        int id = Integer.parseInt(request.getParameter("id"));
//        
//        if (snippetDAO.deleteSnippet(id)) {
//            response.sendRedirect("explore");
//        } else {
//            response.getWriter().println("Error deleting snippet!");
//        }
//    }
    
//    also delete photo
 // DeleteServlet.java ထဲမှာ ဒီလိုလေး ပြင်ရင် ပိုကောင်းပါတယ်
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // ၁။ Snippet အချက်အလက်ကို အရင်ယူပြီး ပုံရှိရင် ဖျက်မယ်
            Snippet snippet = snippetDAO.getSnippetById(id);
            if (snippet != null && snippet.getImagePath() != null) {
                String uploadPath = getServletContext().getRealPath("/") + snippet.getImagePath();
                File file = new File(uploadPath);
                if (file.exists()) {
                    file.delete(); // Server folder ထဲက ပုံကို ဖျက်လိုက်တာပါ
                }
            }
            
            // ၂။ ပြီးမှ Database ကနေ ဖျက်မယ်
            if (snippetDAO.deleteSnippet(id)) {
                response.sendRedirect("explore");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("explore?error=1");
        }
    }
}