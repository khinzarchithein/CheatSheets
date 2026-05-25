package com.cheatsheets.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheets.dao.UserDAO;
import com.cheatsheets.config.DBConnect;
import com.cheatsheets.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // DB Connection ယူပြီး Login စစ်မယ်
        UserDAO dao = new UserDAO(DBConnect.getConnection()); 
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Database ထဲက Role ကို စစ်ဆေးတာပါ
            if ("admin".equalsIgnoreCase(user.getRole())) {
                // Admin ဖြစ်ရင် index.jsp (Admin Dashboard) ကိုသွားမယ်
               // response.sendRedirect("explore");
            	 response.sendRedirect("index.jsp");
            } else {
                // ရိုးရိုး User ဖြစ်ရင် explore (Public Home) ကိုသွားမယ်
                response.sendRedirect("explore");
            }
        } else {
            // Login မှားရင် login page ကို ပြန်ပို့မယ်
            request.getSession().setAttribute("errorMsg", "Email သို့မဟုတ် Password မှားယွင်းနေပါသည်။");
            response.sendRedirect("login.jsp");
           // response.sendRedirect("explore");// mytest send to explore(publicindex.jsp)
            
        }
    }
}