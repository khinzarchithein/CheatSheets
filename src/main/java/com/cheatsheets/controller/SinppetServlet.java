package com.cheatsheets.controller;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheets.dao.CategoryDAO;
import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Category;
import com.cheatsheets.model.Snippet;

/**
 * Servlet implementation class SinppetServlet
 */

@WebServlet("/home")
public class SinppetServlet extends HttpServlet {

   private static final long serialVersionUID = 1L;
   private SnippetDAO snippetDAO = new SnippetDAO();

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          
          // ၁။ လက်ရှိ Login ဝင်ထားတဲ့ User ID ကို အရင်ယူရပါမယ်
          javax.servlet.http.HttpSession session = request.getSession();
          com.cheatsheets.model.User user = (com.cheatsheets.model.User) session.getAttribute("user");
          int currentUserId = (user != null) ? user.getId() : 0; // Login မဝင်ထားရင် 0 ပေးမယ်

          String keyword = request.getParameter("search");
          String catIdParam = request.getParameter("category");

          List<Snippet> snippetList;
          
          CategoryDAO catDAO = new CategoryDAO(com.cheatsheets.config.DBConnect.getConnection()); 
          List<Category> categoryList = catDAO.getAllCategories();

          // ၂။ DAO ရဲ့ method တွေကို ခေါ်တဲ့အခါ currentUserId ကိုပါ ထည့်ပေးလိုက်ပါ
          if (catIdParam != null && !catIdParam.isEmpty()) {
              try {
                  int categoryId = Integer.parseInt(catIdParam);
                  // ဒီနေရာမှာလည်း မင်းရဲ့ DAO ထဲက getSnippetsByCategory မှာ currentUserId လက်ခံအောင် ပြင်ဖို့လိုပါမယ်
                  snippetList = snippetDAO.getSnippetsByCategory(categoryId, currentUserId); 
              } catch (NumberFormatException e) {
                  snippetList = snippetDAO.getAllSnippets(currentUserId);
              }
          } 
          else if (keyword != null && !keyword.trim().isEmpty()) {
              // searchSnippets မှာလည်း currentUserId ပါသွားအောင် ပြင်ရပါမယ်
              snippetList = snippetDAO.searchSnippets(keyword, currentUserId);
          } 
          else {
              // ဒီနေရာက error တက်နေတဲ့ နေရာပါ - currentUserId ထည့်ပေးလိုက်ပါ
              snippetList = snippetDAO.getAllSnippets(currentUserId);
          }

          request.setAttribute("snippets", snippetList);
          request.setAttribute("categories", categoryList);
          
          request.getRequestDispatcher("index.jsp").forward(request, response);
   }
}
