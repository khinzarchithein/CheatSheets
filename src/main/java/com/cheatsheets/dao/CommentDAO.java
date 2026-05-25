//comment and reply section
package com.cheatsheets.dao;

import com.cheatsheets.model.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/cheatsheets_db", "root", "123456");
    }

    // Comment နှင့် Reply အသစ်သိမ်းရန် (parentCommentId ပါဝင်လာမည်)
    public boolean addComment(int snippetId, int userId, String text, int parentCommentId) {
        String sql = "INSERT INTO comments (snippet_id, user_id, comment_text, parent_comment_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, snippetId);
            ps.setInt(2, userId);
            ps.setString(3, text);
         // CommentDAO.java ရဲ့ addComment ထဲက ps.setInt(4, parentCommentId) နေရာမှာ ဒါနဲ့ အစားထိုးပါ -

            if (parentCommentId == 0) {
                ps.setNull(4, java.sql.Types.INTEGER); // ပင်မ Comment ဆိုလျှင် DB ထဲ၌ NULL ဟု သိမ်းမည်
            } else {
                ps.setInt(4, parentCommentId); // Reply ဖြစ်လျှင် ID နံပါတ် အစစ်အတိုင်း သိမ်းမည်
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Snippet တစ်ခုချင်းစီရဲ့ Comment များနှင့် Reply များကို ပင်မ Comment အောက်တွင် အစဉ်လိုက်စီယူရန်
    public List<Comment> getCommentsBySnippetId(int snippetId) {
        List<Comment> list = new ArrayList<>();
        // Reply များကို ပင်မ Comment များနှင့်အတူ အချိန်အစဉ်လိုက် မှန်ကန်စွာ ထွက်လာစေရန် စီထားပါသည်
        String sql = "SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id " +
                     "WHERE c.snippet_id = ? " +
                     "ORDER BY CASE WHEN c.parent_comment_id = 0 THEN c.id ELSE c.parent_comment_id END ASC, c.created_at ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, snippetId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setSnippetId(rs.getInt("snippet_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setUsername(rs.getString("username"));
                    c.setCommentText(rs.getString("comment_text"));
                    c.setCreatedAt(rs.getTimestamp("created_at").toString());
                    c.setParentCommentId(rs.getInt("parent_comment_id")); // Model ထဲသို့ ထည့်သွင်းခြင်း
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 // ၁။ စနစ်ထဲရှိသမျှ Comment အားလုံးကို Admin Dashboard အတွက် ဆွဲထုတ်ရန်
    public List<Comment> getAllCommentsForAdmin() {
        List<Comment> list = new ArrayList<>();
        // ဘယ် Snippet အောက်ကလဲ သိနိုင်ရန် snippets table နှင့်ပါ JOIN ထားပါသည်
        String sql = "SELECT c.*, u.username, s.title as snippet_title " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "JOIN snippets s ON c.snippet_id = s.id " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setSnippetId(rs.getInt("snippet_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setUsername(rs.getString("username"));
                c.setCommentText(rs.getString("comment_text"));
                c.setCreatedAt(rs.getTimestamp("created_at").toString());
                c.setParentCommentId(rs.getInt("parent_comment_id"));
                // Note: Comment Model ထဲ၌ snippetTitle field မရှိလျှင်ပင် 
                // ယာယီအားဖြင့် အဆင်ပြေစေရန် စာသားများကို သိမ်းဆည်းရန် သုံးနိုင်ပါသည်
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ၂။ Admin က ခလုတ်နှိပ်လျှင် Comment ကို ID အလိုက် ဖျက်ရန်
    public boolean deleteCommentByAdmin(int commentId) {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}