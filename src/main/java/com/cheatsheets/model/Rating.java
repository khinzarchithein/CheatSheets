package com.cheatsheets.model;

import java.sql.Timestamp;

public class Rating {
    private int id;
    private int snippetId;
    private int userId;
    private int ratingValue;
    private Timestamp createdAt;

    public Rating() {}

    public Rating(int id, int snippetId, int userId, int ratingValue) {
        this.id = id;
        this.snippetId = snippetId;
        this.userId = userId;
        this.ratingValue = ratingValue;
    }

    // --- Getters and Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSnippetId() { return snippetId; }
    public void setSnippetId(int snippetId) { this.snippetId = snippetId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRatingValue() { return ratingValue; }
    public void setRatingValue(int ratingValue) { this.ratingValue = ratingValue; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
