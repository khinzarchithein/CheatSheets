// comment and reply
package com.cheatsheets.controller;

import com.cheatsheets.dao.CommentDAO;
import com.cheatsheets.model.Comment;
import com.cheatsheets.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    // GET: Comment & Reply list ကို JSON ပုံစံဖြင့် လှမ်းယူရန်
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        int snippetId = Integer.parseInt(request.getParameter("snippetId"));
        List<Comment> comments = commentDAO.getCommentsBySnippetId(snippetId);
        
        PrintWriter out = response.getWriter();
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < comments.size(); i++) {
            Comment c = comments.get(i);
            // Frontend က ခွဲခြားဖတ်နိုင်ရန် "id" နှင့် "parentCommentId" ပါ JSON ထဲ ထည့်ပေးလိုက်ပါသည်
            json.append(String.format("{\"id\":%d,\"username\":\"%s\",\"text\":\"%s\",\"time\":\"%s\",\"parentCommentId\":%d}", 
                    c.getId(),
                    c.getUsername(), 
                    c.getCommentText().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", ""), 
                    c.getCreatedAt().substring(0, 16),
                    c.getParentCommentId()));
            if (i < comments.size() - 1) json.append(",");
        }
        json.append("]");
        out.print(json.toString());
        out.flush();
    }

    // POST: Comment သို့မဟုတ် Reply အသစ်တင်ရန်
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.getWriter().print("login_required");
            return;
        }

        int snippetId = Integer.parseInt(request.getParameter("snippetId"));
        String commentText = request.getParameter("commentText");
        
        // Reply အတွက် parentCommentId ကို ဖတ်ယူခြင်း (မပါလာလျှင် default 0 ဖြစ်မည်)
     // CommentServlet.java ရဲ့ doPost ထဲက parentIdParam စစ်သည့်နေရာကို အောက်ပါအတိုင်း သေချာအောင် ပြင်ပါ -

        int parentCommentId = 0;
        String parentIdParam = request.getParameter("parentCommentId");
        if (parentIdParam != null && !parentIdParam.trim().isEmpty() && !parentIdParam.equals("undefined") && !parentIdParam.equals("null")) {
            parentCommentId = Integer.parseInt(parentIdParam.trim());
        }

        if (commentText != null && !commentText.trim().isEmpty()) {
            boolean success = commentDAO.addComment(snippetId, user.getId(), commentText.trim(), parentCommentId);
            if (success) {
                response.getWriter().print("success");
            } else {
                response.getWriter().print("error");
            }
        }
    }
}