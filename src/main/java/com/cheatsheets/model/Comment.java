package com.cheatsheets.model;

public class Comment {
    private int id;
    private int snippetId;
    private int userId;
    private String username;    // UI မှာ ဘယ်သူရေးလဲဆိုတာ နာမည်ပြဖို့
    private String commentText;
    private String createdAt;   // အချိန်ပြဖို့
    private int parentCommentId;
    public Comment() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSnippetId() { return snippetId; }
    public void setSnippetId(int snippetId) { this.snippetId = snippetId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
 // Getter Method
    public int getParentCommentId() {
        return parentCommentId;
    }

    // Setter Method
    public void setParentCommentId(int parentCommentId) {
        this.parentCommentId = parentCommentId;
    }
}