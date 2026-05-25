<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - CheatSheets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .register-card { width: 100%; max-width: 400px; padding: 2rem; border-radius: 15px; background: white; shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .btn-primary { background-color: #1a3a5f; border: none; }
        .btn-primary:hover { background-color: #122b46; }
    </style>
</head>
<body>

<div class="register-card shadow">
    <div class="text-center mb-4">
        <h2 class="fw-bold" style="color: #1a3a5f;">Create Account</h2>
        <p class="text-muted">Join our community of developers</p>
    </div>

    <%-- Error Message ပြဖို့ --%>
    <% 
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
    %>
        <div class="alert alert-danger p-2 text-center" style="font-size: 14px;">
            <%= errorMsg %>
        </div>
    <% 
        session.removeAttribute("errorMsg");
        } 
    %>

    <form action="signup" method="POST">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" placeholder="Enter your name" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required>
        </div>
        
        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Sign Up</button>
    </form>

    <div class="text-center mt-4">
        <p class="mb-0 text-muted">Already have an account? <a href="login.jsp" class="text-decoration-none fw-bold">Login</a></p>
        <hr>
        <a href="explore" class="text-muted text-decoration-none" style="font-size: 14px;">Continue as Guest</a>
    </div>
</div>

</body>
</html>