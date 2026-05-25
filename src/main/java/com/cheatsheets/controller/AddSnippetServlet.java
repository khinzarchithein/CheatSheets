//with file upload
package com.cheatsheets.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part; // File Part အတွက် လိုအပ်ပါတယ်

import com.cheatsheets.config.DBConnect;
import com.cheatsheets.dao.CategoryDAO;
import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Category;
import com.cheatsheets.model.Snippet;
import com.cheatsheets.model.User;

@WebServlet("/add-snippet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddSnippetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        CategoryDAO catDAO = new CategoryDAO(DBConnect.getConnection());
        List<Category> categoryList = catDAO.getAllCategories();
        request.setAttribute("categories", categoryList);
        request.getRequestDispatcher("add-snippet.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // ၁. စာသားအချက်အလက်များကို ရယူခြင်း
            String title = request.getParameter("title");
            String desc = request.getParameter("description");
            String code = request.getParameter("codeContent");
            String catIdStr = request.getParameter("categoryId");

            if (title == null || code == null || catIdStr == null || title.isEmpty() || code.isEmpty()) {
                request.setAttribute("errorMsg", "Title, Code and Category are required!");
                doGet(request, response); 
                return;
            }

            // ၂. Image Upload Handling (ဒီအပိုင်းက အသစ်ပါ)
            Part filePart = request.getPart("image"); // Form ထဲက input name နဲ့ တူရပါမယ်
            String fileName = filePart.getSubmittedFileName();
            String imagePath = null;

            if (fileName != null && !fileName.isEmpty()) {
                // Project ရဲ့ webapp ထဲမှာ uploads folder path ကို ယူခြင်း
                String baseDir = getServletContext().getRealPath("");
         //    String uploadPath = baseDir + File.separator + "uploads";
                String uploadPath = "C:/Users/Dell/Desktop/cheatsheetproject/CheatSheets/src/main/webapp/uploads";
                
                
                // Folder မရှိရင် Auto ဆောက်ပေးမယ့် Logic
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir(); 
                }

                // File နာမည်မတူအောင် Timestamp ထည့်ခြင်း
                fileName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + File.separator + fileName);
                
                // Database ထဲမှာ သိမ်းမယ့် လိပ်စာ (ဥပမာ- uploads/12345_pic.jpg)
                imagePath = "uploads/" + fileName;
            }

            int catId = Integer.parseInt(catIdStr);

            Snippet newSnippet = new Snippet();
            newSnippet.setTitle(title);
            newSnippet.setDescription(desc);
            newSnippet.setCodeContent(code);
            newSnippet.setCategoryId(catId);
            newSnippet.setUserId(user.getId()); 
            newSnippet.setImagePath(imagePath); // Image Path ကို Snippet Object ထဲ ထည့်ခြင်း
            SnippetDAO snippetDAO = new SnippetDAO();
            // မှတ်ချက်- SnippetDAO ရဲ့ insertSnippet() ထဲမှာ imagePath ပါ သိမ်းဖို့ လိုပါမယ်
            if(snippetDAO.insertSnippet(newSnippet)) {
                response.sendRedirect("home"); 
            } else {
                request.setAttribute("errorMsg", "Database error: Could not add snippet.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add-snippet?error=1");
        }
    }
}