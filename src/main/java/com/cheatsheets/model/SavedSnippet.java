package com.cheatsheets.model;

import java.sql.Timestamp;

public class SavedSnippet {
    private int id;
    private int userId;
    private int snippetId;
    private Timestamp savedAt;
    
    // UI မှာ ပြန်ပြတဲ့အခါ အသုံးဝင်အောင် Snippet ရဲ့ အချက်အလက်တချို့ကိုပါ တစ်ခါတည်း ထည့်ထားလို့ရပါတယ်
    private String snippetTitle;
    private String categoryName;

    public SavedSnippet() {}

    // Constructor
    public SavedSnippet(int id, int userId, int snippetId, Timestamp savedAt) {
        this.id = id;
        this.userId = userId;
        this.snippetId = snippetId;
        this.savedAt = savedAt;
    }

    // --- Getters and Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getSnippetId() { return snippetId; }
    public void setSnippetId(int snippetId) { this.snippetId = snippetId; }

    public Timestamp getSavedAt() { return savedAt; }
    public void setSavedAt(Timestamp savedAt) { this.savedAt = savedAt; }

    public String getSnippetTitle() { return snippetTitle; }
    public void setSnippetTitle(String snippetTitle) { this.snippetTitle = snippetTitle; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}