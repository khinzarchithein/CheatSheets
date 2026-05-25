package com.cheatsheets.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
	public class Category {
	    private int id;
	    private String name;
	    private int parentId;

	    public Category() {}

	    // Getters and Setters
//	    public int getId() { return id; }
//	    public void setId(int id) { this.id = id; }
//
//	    public String getName() { return name; }
//	    public void setName(String name) { this.name = name; }
//
//	    public int getParentId() { return parentId; }
//	    public void setParentId(int parentId) { this.parentId = parentId; }
	}

