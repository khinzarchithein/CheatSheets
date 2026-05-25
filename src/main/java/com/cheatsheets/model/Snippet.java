package com.cheatsheets.model;

public class Snippet {
    private int id;
    private String title;
    private String description;
    private String codeContent;
    private int categoryId;
    private String categoryName;
   private boolean isSaved; // User သိမ်းထားခြင်း ရှိ/မရှိ သိဖို့
 public boolean isIsSaved() { return isSaved; }
    public void setIsSaved(boolean isSaved) { this.isSaved = isSaved; }
    // --- အသစ်ထပ်တိုးလိုက်တဲ့ Field များ ---
    private int userId;           // Snippet တင်တဲ့ User ရဲ့ ID ကို မှတ်ရန်
    private double averageRating; // Snippet ရဲ့ ပျမ်းမျှ Rating ကို ပြရန်
    private int userRating;
    private String imagePath;


    public Snippet() {}

    // Constructor အသစ် (userId ပါဝင်သော)
    public Snippet(int id, String title, String description, String codeContent, int categoryId, int userId) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.codeContent = codeContent;
        this.categoryId = categoryId;
        this.userId = userId;
    }

    // --- Getters and Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCodeContent() { return codeContent; }
    public void setCodeContent(String codeContent) { this.codeContent = codeContent; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    // User ID အတွက် Getter & Setter
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // Average Rating အတွက် Getter & Setter
    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
    public int getUserRating() { return userRating; }
    public void setUserRating(int userRating) { this.userRating = userRating; }
    ////
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}