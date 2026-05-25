// package com.cheatsheets.dao;
//
//import com.cheatsheets.model.Snippet;
//import com.cheatsheets.config.DBConnect;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class SnippetDAO {
//    private Connection conn;
//    private RatingDAO ratingDAO = new RatingDAO();
//
//    public SnippetDAO(Connection conn) {
//        this.conn = conn;
//    }
//
//    public SnippetDAO() {
//    }
//
//    // ၁။ အားလုံးကို ဆွဲထုတ်ခြင်း (Modified)
//    public List<Snippet> getAllSnippets(int currentUserId) {
//        List<Snippet> snippets = new ArrayList<>();
//        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
//                     "LEFT JOIN categories c ON s.category_id = c.id " +
//                     "ORDER BY s.id DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                Snippet s = populateSnippet(rs, currentUserId);
//                snippets.add(s);
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return snippets;
//    }
//    //insert snippet
//    public boolean insertSnippet(Snippet snippet) {
//        String sql = "INSERT INTO snippets (title, description, code_content, category_id, user_id) VALUES (?, ?, ?, ?, ?)";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setString(1, snippet.getTitle());
//            ps.setString(2, snippet.getDescription());
//            ps.setString(3, snippet.getCodeContent());
//            ps.setInt(4, snippet.getCategoryId());
//            ps.setInt(5, snippet.getUserId()); // User ID ကို သိမ်းဆည်းခြင်း
//            
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    // ၂။ Search လုပ်ခြင်း (Modified - userId ပါဝင်သည်)
//    public List<Snippet> searchSnippets(String query, int currentUserId) {
//        List<Snippet> list = new ArrayList<>();
//        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
//                     "LEFT JOIN categories c ON s.category_id = c.id " +
//                     "WHERE s.title LIKE ? OR s.description LIKE ? ORDER BY s.id DESC";
//        
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, "%" + query + "%");
//            ps.setString(2, "%" + query + "%");
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(populateSnippet(rs, currentUserId));
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return list;
//    }
//
//    // ၃။ Category အလိုက် ဆွဲထုတ်ခြင်း (Modified - userId ပါဝင်သည်)
//    public List<Snippet> getSnippetsByCategory(int categoryId, int currentUserId) {
//        List<Snippet> snippets = new ArrayList<>();
//        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
//                     "LEFT JOIN categories c ON s.category_id = c.id WHERE s.category_id = ? ORDER BY s.id DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, categoryId);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                snippets.add(populateSnippet(rs, currentUserId));
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return snippets;
//    }
//
//    // ၄။ Record တစ်ခုချင်းစီကို Data ဖြည့်ပေးမယ့် Helper Method (重複 code တွေ လျှော့ဖို့)
//    private Snippet populateSnippet(ResultSet rs, int currentUserId) throws SQLException {
//        Snippet s = new Snippet();
//        int snipId = rs.getInt("id");
//        s.setId(snipId);
//        s.setTitle(rs.getString("title"));
//        s.setDescription(rs.getString("description"));
//        s.setCodeContent(rs.getString("code_content"));
//        s.setCategoryId(rs.getInt("category_id"));
//        s.setCategoryName(rs.getString("category_name"));
//        s.setUserId(rs.getInt("user_id"));
//        
//        // Rating နဲ့ Save status ကို တစ်ခါတည်း သတ်မှတ်မယ်
//        s.setAverageRating(ratingDAO.getAverageRating(snipId));//public rating
//        //to check user rating
//        if (currentUserId > 0) {
//        	s.setUserRating(getUserPersonalRating(currentUserId, snipId));
//            s.setIsSaved(checkIfSaved(currentUserId, snipId));
//        }
//        return s;
//    }
//
//    // User တစ်ယောက်တည်း ပေးခဲ့တဲ့ rating ကိုပဲ ဆွဲထုတ်ပေးမယ့် method
//    private int getUserPersonalRating(int userId, int snippetId) {
//        int rating = 0;
//        String sql = "SELECT rating_value FROM ratings WHERE user_id = ? AND snippet_id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setInt(2, snippetId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                rating = rs.getInt("rating_value");
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return rating;
//    }
//
//    // ၅။ Save Status စစ်ဆေးခြင်း
//    private boolean checkIfSaved(int userId, int snippetId) {
//boolean isSaved = false;
//        String sql = "SELECT 1 FROM saved_snippets WHERE user_id = ? AND snippet_id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setInt(2, snippetId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) isSaved = true;
//        } catch (Exception e) { e.printStackTrace(); }
//        return isSaved;
//    }
//
//    // --- ကျန်တဲ့ Method များ (Update/Delete/GetById) ---
//    public List<Snippet> getSavedSnippetsByUser(int userId) {
//        List<Snippet> list = new ArrayList<>();
//        // Join query သုံးပြီး သိမ်းထားတဲ့ snippet data တွေကို ဆွဲထုတ်မယ်
//        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
//                     "JOIN saved_snippets ss ON s.id = ss.snippet_id " +
//                     "LEFT JOIN categories c ON s.category_id = c.id " +
//                     "WHERE ss.user_id = ? ORDER BY ss.id DESC";
//
//        try (Connection conn = com.cheatsheets.config.DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//            
//            while (rs.next()) {
//                // အရှေ့မှာ ရေးခဲ့တဲ့ populateSnippet method လေးကို ပြန်သုံးပါမယ်
//                // သိမ်းထားတဲ့ list ဖြစ်လို့ isSaved ကို true လို့ တန်းပေးလို့ရပါတယ်
//                Snippet s = populateSnippet(rs, userId);
//                s.setIsSaved(true); 
//                list.add(s);
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return list;
//    }
//    public Snippet getSnippetById(int id) {
//        Snippet snippet = null;
//        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
//                     "LEFT JOIN categories c ON s.category_id = c.id WHERE s.id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                snippet = new Snippet();
//                snippet.setId(rs.getInt("id"));
//                snippet.setTitle(rs.getString("title"));
//                snippet.setDescription(rs.getString("description"));
//                snippet.setCodeContent(rs.getString("code_content"));
//                snippet.setCategoryId(rs.getInt("category_id"));
//                snippet.setCategoryName(rs.getString("category_name"));
//                snippet.setUserId(rs.getInt("user_id"));
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return snippet;
//    }
//
//    public boolean updateSnippet(Snippet snippet) {
//        String sql = "UPDATE snippets SET title=?, description=?, code_content=?, category_id=? WHERE id=?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, snippet.getTitle());
//            ps.setString(2, snippet.getDescription());
//            ps.setString(3, snippet.getCodeContent());
//            ps.setInt(4, snippet.getCategoryId());
//            ps.setInt(5, snippet.getId());
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) { e.printStackTrace(); return false; }
//    }
//
//    public boolean deleteSnippet(int id) {
//        String sql = "DELETE FROM snippets WHERE id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) { e.printStackTrace(); return false; }
//    }
//}

//file upload
package com.cheatsheets.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cheatsheets.config.DBConnect;
import com.cheatsheets.model.Snippet;


public class SnippetDAO {
    private Connection conn;
    private RatingDAO ratingDAO = new RatingDAO();

    public SnippetDAO(Connection conn) {
        this.conn = conn;
    }

    public SnippetDAO() {
    }

    // ၁။ အားလုံးကို ဆွဲထုတ်ခြင်း (Modified)
    public List<Snippet> getAllSnippets(int currentUserId) {
        List<Snippet> snippets = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "ORDER BY s.id DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Snippet s = populateSnippet(rs, currentUserId);
                snippets.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return snippets;
    }

    // --- အသစ်ပြင်ဆင်ထားသော insertSnippet (image_path ပါဝင်သည်) ---
    public boolean insertSnippet(Snippet snippet) {
        String sql = "INSERT INTO snippets (title, description, code_content, category_id, user_id, image_path) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getDescription());
            ps.setString(3, snippet.getCodeContent());
            ps.setInt(4, snippet.getCategoryId());
            ps.setInt(5, snippet.getUserId());
            ps.setString(6, snippet.getImagePath()); // image_path ကို သိမ်းဆည်းခြင်း
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၂။ Search လုပ်ခြင်း
    public List<Snippet> searchSnippets(String query, int currentUserId) {
        List<Snippet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.title LIKE ? OR s.description LIKE ? ORDER BY s.id DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(populateSnippet(rs, currentUserId));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ၃။ Category အလိုက် ဆွဲထုတ်ခြင်း
    public List<Snippet> getSnippetsByCategory(int categoryId, int currentUserId) {
        List<Snippet> snippets = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
                     "LEFT JOIN categories c ON s.category_id = c.id WHERE s.category_id = ? ORDER BY s.id DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                snippets.add(populateSnippet(rs, currentUserId));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return snippets;
    }

    // --- အသစ်ပြင်ဆင်ထားသော Helper Method (image_path ကို Model ထဲ ထည့်ပေးသည်) ---
    private Snippet populateSnippet(ResultSet rs, int currentUserId) throws SQLException {
    	Snippet s = new Snippet();
        int snipId = rs.getInt("id");
        s.setId(snipId);
        s.setTitle(rs.getString("title"));
        s.setDescription(rs.getString("description"));
        s.setCodeContent(rs.getString("code_content"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setCategoryName(rs.getString("category_name"));
        s.setUserId(rs.getInt("user_id"));
        s.setImagePath(rs.getString("image_path")); // Database က path ကို Model ထဲ ထည့်ခြင်း
        
        s.setAverageRating(ratingDAO.getAverageRating(snipId));
        if (currentUserId > 0) {
            s.setUserRating(getUserPersonalRating(currentUserId, snipId));
            s.setIsSaved(checkIfSaved(currentUserId, snipId));
        }
        return s;
    }

    // User တစ်ယောက်တည်း ပေးခဲ့တဲ့ rating ကိုပဲ ဆွဲထုတ်ပေးမယ့် method
    private int getUserPersonalRating(int userId, int snippetId) {
        int rating = 0;
        String sql = "SELECT rating_value FROM ratings WHERE user_id = ? AND snippet_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, snippetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                rating = rs.getInt("rating_value");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rating;
    }

    // ၅။ Save Status စစ်ဆေးခြင်း
    private boolean checkIfSaved(int userId, int snippetId) {
        boolean isSaved = false;
        String sql = "SELECT 1 FROM saved_snippets WHERE user_id = ? AND snippet_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, snippetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) isSaved = true;
        } catch (Exception e) { e.printStackTrace(); }
        return isSaved;
    }

    public List<Snippet> getSavedSnippetsByUser(int userId) {
        List<Snippet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
                     "JOIN saved_snippets ss ON s.id = ss.snippet_id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE ss.user_id = ? ORDER BY ss.id DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Snippet s = populateSnippet(rs, userId);
                s.setIsSaved(true); 
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Snippet getSnippetById(int id) {
        Snippet snippet = null;
        String sql = "SELECT s.*, c.name AS category_name FROM snippets s " +
                     "LEFT JOIN categories c ON s.category_id = c.id WHERE s.id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                snippet = new Snippet();
                snippet.setId(rs.getInt("id"));
                snippet.setTitle(rs.getString("title"));
                snippet.setDescription(rs.getString("description"));
                snippet.setCodeContent(rs.getString("code_content"));
                snippet.setCategoryId(rs.getInt("category_id"));
                snippet.setCategoryName(rs.getString("category_name"));
                snippet.setUserId(rs.getInt("user_id"));
                snippet.setImagePath(rs.getString("image_path")); // ဒီမှာလည်း image path ထည့်ပေးလိုက်ပါတယ်
            }
        } catch (Exception e) { e.printStackTrace(); }
        return snippet;
    }
// Update မှာလည်း လိုအပ်ရင် image_path ပါ ပြင်နိုင်အောင် တိုးချဲ့နိုင်ပါတယ်
//    public boolean updateSnippet(Snippet snippet) {
//        String sql = "UPDATE snippets SET title=?, description=?, code_content=?, category_id=? WHERE id=?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, snippet.getTitle());
//            ps.setString(2, snippet.getDescription());
//            ps.setString(3, snippet.getCodeContent());
//            ps.setInt(4, snippet.getCategoryId());
//            ps.setInt(5, snippet.getId());
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) { e.printStackTrace(); return false; }
//    }
    //
    public boolean updateSnippet(Snippet snippet) {
        // 🛑 category_id ပြီးရင် ကော်မာ (,) လိုပါတယ်၊ ပြီးတော့ image_path=? ကို ထည့်ရပါမယ်
        String sql = "UPDATE snippets SET title=?, description=?, code_content=?, category_id=?, image_path=? WHERE id=?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, snippet.getTitle());
            ps.setString(2, snippet.getDescription());
            ps.setString(3, snippet.getCodeContent());
            ps.setInt(4, snippet.getCategoryId());
            ps.setString(5, snippet.getImagePath()); // 🖼️ image_path အတွက် string parameter ထည့်ပေးရမယ်
            ps.setInt(6, snippet.getId());           // 🆔 id က နောက်ဆုံး (နံပါတ် ၆) မှာ ဖြစ်ရပါမယ်

            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
    
//    public boolean deleteSnippet(int id) {
//        String sql = "DELETE FROM snippets WHERE id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) { e.printStackTrace(); return false; }
//    }
    public boolean deleteSnippet(int id) {
        // ၁။ အရင်ဆုံး Database ထဲက ပုံလမ်းကြောင်း (image_path) ကို ယူမယ်
        String getImgSql = "SELECT image_path FROM snippets WHERE id = ?";
        String deleteSql = "DELETE FROM snippets WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection()) {
            // ပုံဖိုင်ကို Server ပေါ်ကနေ အရင်ဖျက်ဖို့ ကြိုးစားမယ်
            try (PreparedStatement psImg = conn.prepareStatement(getImgSql)) {
                psImg.setInt(1, id);
                try (ResultSet rs = psImg.executeQuery()) {
                    if (rs.next()) {
                        String imagePath = rs.getString("image_path");
                        if (imagePath != null && !imagePath.isEmpty()) {
                            // လက်ရှိ context (server folder) ထဲက path ကို ယူမယ်
                            // မှတ်ချက်- ဒီနေရာမှာ ServletContext မရှိရင် Servlet ဘက်ကနေပဲ ဖျက်တာ ပိုကောင်းပါတယ်
                        }
                    }
                }
            }

            // ၂။ Database ထဲက data ကို ဖျက်မယ်
            try (PreparedStatement psDel = conn.prepareStatement(deleteSql)) {
                psDel.setInt(1, id);
                return psDel.executeUpdate() > 0;
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
//    top rated method
 // parameter အဖြစ် (int currentUserId) ကို ထည့်ပေးလိုက်ပါ
    public List<Snippet> getTopRatedSnippets(int currentUserId) {
        List<Snippet> list = new ArrayList<>();
        // snippets table ထဲက average_rating column ကို သုံးပြီး အများဆုံးကောင်ကနေ စီမယ်
        String sql = "SELECT * FROM snippets ORDER BY average_rating DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            SavedSnippetDAO savedDao = new SavedSnippetDAO(); 
            
            while (rs.next()) {
                Snippet s = new Snippet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                s.setImagePath(rs.getString("image_path"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setUserId(rs.getInt("user_id"));
                
                // မင်းရဲ့ Model ထဲက နာမည်အတိုင်း averageRating ကို set လုပ်မယ်
                s.setAverageRating(rs.getDouble("average_rating")); 
                
                // Login ဝင်ထားရင် အရင်ကအတိုင်း Save status ကို စစ်ပေးမယ်
                if (currentUserId > 0) {
                    // မင်းရဲ့ model ထဲမှာ setIsSaved လို့ ပေးထားတဲ့အတွက် အဲဒီအတိုင်း ခေါ်ပေးထားပါတယ်
                    s.setIsSaved(savedDao.isSnippetSaved(currentUserId, s.getId())); 
                }
                
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
