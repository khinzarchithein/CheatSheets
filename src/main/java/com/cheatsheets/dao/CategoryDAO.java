
package com.cheatsheets.dao;

import java.sql.*;
import java.util.*;
import com.cheatsheets.model.Category;
import com.cheatsheets.config.DBConnect;

public class CategoryDAO {
    private Connection conn;

    // ၁။ Constructor အလွတ် (PublicHomeServlet အတွက်)
    public CategoryDAO() {
        this.conn = DBConnect.getConnection();
    }

    // ၂။ Connection ပါတဲ့ Constructor (တခြား Servlet တွေ အရင်က သုံးထားတာအတွက်)
    // ဒါလေး မရှိလို့ တခြားနေရာတွေမှာ error တက်ကုန်တာပါ
    public CategoryDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        // Connection မရှိရင် အသစ်ယူမယ်၊ ရှိရင် ရှိတာသုံးမယ်
        Connection localConn = (this.conn != null) ? this.conn : DBConnect.getConnection();
        
        String sql = "SELECT * FROM categories ORDER BY name ASC";
        
        try (PreparedStatement ps = localConn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}