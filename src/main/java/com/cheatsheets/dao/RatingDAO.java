package com.cheatsheets.dao;



import java.sql.*;
import com.cheatsheets.config.DBConnect;

public class RatingDAO {

    // ၁။ Rating အသစ်ထည့်ခြင်း သို့မဟုတ် အဟောင်းကို ပြင်ခြင်း (Upsert logic)
//    public boolean addOrUpdateRating(int snippetId, int userId, int ratingValue) {
//        // တစ်ယောက်ကို တစ်ကြိမ်ပဲ ပေးလို့ရအောင် (Duplicate key ဖြစ်ရင် update လုပ်မယ်)
//        String sql = "INSERT INTO ratings (snippet_id, user_id, rating_value) VALUES (?, ?, ?) " +
//                     "ON DUPLICATE KEY UPDATE rating_value = ?";
//        
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setInt(1, snippetId);
//            ps.setInt(2, userId);
//            ps.setInt(3, ratingValue);
//            ps.setInt(4, ratingValue); // Update အတွက်
//            
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
	public boolean addOrUpdateRating(int snippetId, int userId, int ratingValue) {
	    // ၁။ Ratings table ထဲမှာ data အရင်သိမ်းမယ်
	    String sql = "INSERT INTO ratings (snippet_id, user_id, rating_value) VALUES (?, ?, ?) " +
	                 "ON DUPLICATE KEY UPDATE rating_value = ?";
	    
	    try (Connection conn = DBConnect.getConnection()) {
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setInt(1, snippetId);
	        ps.setInt(2, userId);
	        ps.setInt(3, ratingValue);
	        ps.setInt(4, ratingValue);
	        
	        // Rating သိမ်းတာ အောင်မြင်ခဲ့ရင်...
	        if (ps.executeUpdate() > 0) {
	            
	            // ၂။ အဲဒီ Snippet ရဲ့ ပျမ်းမျှ Rating အသစ်ကို ပြန်တွက်မယ်
	            double newAvg = getAverageRating(snippetId); // မင်းရဲ့ လက်ရှိ getAverageRating method ကို ခေါ်တာပါ
	            
	            // ၃။ Snippets table ထဲက average_rating column ကို သွားပြီး Update လုပ်မယ်
	            String updateSql = "UPDATE snippets SET average_rating = ? WHERE id = ?";
	            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
	                psUpdate.setDouble(1, newAvg);
	                psUpdate.setInt(2, snippetId);
	                psUpdate.executeUpdate();
	            }
	            
	            return true;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

    // ၂။ Snippet တစ်ခုချင်းစီရဲ့ ပျမ်းမျှ Rating ကို တွက်ချက်ခြင်း
    public double getAverageRating(int snippetId) {
        String sql = "SELECT AVG(rating_value) as avg_rating FROM ratings WHERE snippet_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, snippetId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // နသမတိုင် ၂ နေရာအထိ ယူမယ်
                return Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // ၃။ User တစ်ယောက်က ဒီ snippet ကို rating ပေးထားပြီးပြီလား စစ်ဆေးရန်
    public int getUserRating(int snippetId, int userId) {
        String sql = "SELECT rating_value FROM ratings WHERE snippet_id = ? AND user_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, snippetId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("rating_value");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // မပေးရသေးရင် ၀ ပြမယ်
    }
}