//also edit photo
package com.cheatsheets.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // ထည့်ရန်
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // ထည့်ရန်

import com.cheatsheets.dao.SnippetDAO;
import com.cheatsheets.model.Snippet;



@WebServlet("/edit-snippet")
@MultipartConfig // 👈 ပုံတင်နိုင်ဖို့ ဒါ မဖြစ်မနေ ပါရပါမယ်
public class EditServlet extends HttpServlet {
    private SnippetDAO snippetDAO = new SnippetDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Snippet existingSnippet = snippetDAO.getSnippetById(id);
            request.setAttribute("snippet", existingSnippet);

            com.cheatsheets.dao.CategoryDAO catDAO = new com.cheatsheets.dao.CategoryDAO(com.cheatsheets.config.DBConnect.getConnection());
            java.util.List<com.cheatsheets.model.Category> categoryList = catDAO.getAllCategories();
            request.setAttribute("categories", categoryList);

            request.getRequestDispatcher("edit-snippet.jsp").forward(request, response);
        } catch (Exception e) { e.printStackTrace(); response.sendRedirect("explore"); }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String desc = request.getParameter("description");
            String code = request.getParameter("codeContent");
            int catId = Integer.parseInt(request.getParameter("categoryId"));

            // ၁။ အရင်ရှိပြီးသား image path ကို ယူထားမယ်
            Snippet existingSnippet = snippetDAO.getSnippetById(id);
            String imagePath = existingSnippet.getImagePath(); 

            // ၂။ ပုံအသစ် ရွေးထားရင် သိမ်းမယ်
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // မင်းရဲ့ Project uploads folder လိပ်စာအမှန်ကို ဒီမှာ ထည့်ပါ
                String uploadPath = "C:/Users/Dell/Desktop/cheatsheetproject/CheatSheets/src/main/webapp/uploads";
                
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + java.io.File.separator + fileName);
                imagePath = "uploads/" + fileName;
            }

            Snippet updatedSnippet = new Snippet();
            updatedSnippet.setId(id);
            updatedSnippet.setTitle(title);
            updatedSnippet.setDescription(desc);
            updatedSnippet.setCodeContent(code);
            updatedSnippet.setCategoryId(catId);
            updatedSnippet.setImagePath(imagePath);

            if(snippetDAO.updateSnippet(updatedSnippet)) {
                response.sendRedirect("home");
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}