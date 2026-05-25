package com.cheatsheets.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cheatsheets.config.DBConnect;
import com.cheatsheets.model.Snippet;

public class SavedSnippetDAO {
    
    // ၁။ Snippet ကို Save လုပ်ခြင်း
    public boolean saveSnippet(int userId, int snippetId) {
        String sql = "INSERT IGNORE INTO saved_snippets (user_id, snippet_id) VALUES (?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, snippetId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၂။ Save လုပ်ထားတာကို ပြန်ဖြုတ်ခြင်း (Unsave)
    public boolean unsaveSnippet(int userId, int snippetId) {
        String sql = "DELETE FROM saved_snippets WHERE user_id = ? AND snippet_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, snippetId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၃။ User တစ်ယောက်က ဒီ snippet ကို သိမ်းထားပြီးပြီလား စစ်ဆေးခြင်း
    public boolean isSnippetSaved(int userId, int snippetId) {
        String sql = "SELECT id FROM saved_snippets WHERE user_id = ? AND snippet_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, snippetId);
            ResultSet rs = ps.executeQuery();
            
            return rs.next(); // record ရှိရင် true ပြန်မယ်
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ၄။ မိမိသိမ်းထားသော Snippet များအားလုံးကို ပြန်ထုတ်ယူခြင်း
    public List<Snippet> getSavedSnippetsByUser(int userId) {
        List<Snippet> list = new ArrayList<>();
        // Table နှစ်ခုကို Join ပြီး သိမ်းထားတဲ့ Snippet data တွေအကုန်ယူမယ်
        String sql = "SELECT s.*, c.name as category_name FROM snippets s " +
                     "JOIN saved_snippets ss ON s.id = ss.snippet_id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE ss.user_id = ? ORDER BY ss.saved_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            RatingDAO ratingDAO = new RatingDAO();
            while (rs.next()) {
                Snippet s = new Snippet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                s.setCategoryName(rs.getString("category_name"));
                s.setUserId(rs.getInt("user_id"));
                s.setAverageRating(ratingDAO.getAverageRating(s.getId()));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}