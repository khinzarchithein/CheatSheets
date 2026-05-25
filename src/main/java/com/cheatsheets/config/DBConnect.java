package com.cheatsheets.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
	 static Connection con=null;//static object
	public static void main(String[] args) {Connection con=getConnection();
    
    if(con != null) {
      System.out.println("Connection is working");
    }
 }
 
 public static Connection getConnection() { //static method
   
   try {
     Class.forName("com.mysql.cj.jdbc.Driver");
     String db="jdbc:mysql://localhost:3306/cheatsheets_db";
     String user="root";
     String password="123456";
     
     con=DriverManager.getConnection(db,user,password);
     System.out.println("Database connection is connected!");
   }catch(ClassNotFoundException e){
     System.out.println("JDBC Driver not found");
   }catch(SQLException e){
     System.out.println("Database connection fail: "+e);
   }
   return con;
	
 }
}
