
package com.cheatsheets.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheets.dao.SavedSnippetDAO;
import com.cheatsheets.model.User;

@WebServlet("/save-snippet")
public class SaveSnippetServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Login မဝင်ထားရင် error ပြမယ်
        if (user == null) {
            response.getWriter().write("login_required");
            return;
        }

        try {
            int snippetId = Integer.parseInt(request.getParameter("snippetId"));
            SavedSnippetDAO dao = new SavedSnippetDAO();
            
            String status;
            // ၁။ အရင် သိမ်းထားပြီးသားလား စစ်မယ်
            if (dao.isSnippetSaved(user.getId(), snippetId)) {
                // ရှိပြီးသားဆိုရင် ပြန်ဖျက်မယ် (Unsave)
                dao.unsaveSnippet(user.getId(), snippetId);
                status = "unsaved";
            } else {
                // မရှိသေးရင် အသစ်သိမ်းမယ် (Save)
                dao.saveSnippet(user.getId(), snippetId);
                status = "saved";
            }
            
            // UI ဘက်ကို အခြေအနေ ပြန်ပို့မယ်
            response.getWriter().write(status);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}