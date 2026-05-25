<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
    .back-img {
        background: url("img/bg.jpg"); /* မင်းဆီမှာရှိတဲ့ ပုံလမ်းကြောင်း ပြောင်းပေးပါ */
        height: 100vh;
        width: 100%;
        background-repeat: no-repeat;
        background-size: cover;
    }
</style>
</head>
<body class="back-img">
    
    <%-- Navbar ကို ဒီမှာ Include လုပ်ပေးပါ --%>
    <%-- <%@include file="all_component/navbar.jsp" %> --%>

    <div class="container p-5">
        <div class="row">
            <div class="col-md-4 offset-md-4">
                <div class="card shadow">
                    <div class="card-body">
                        <h4 class="text-center text-primary">Login</h4>

                        <%-- Error Message ပြပေးမယ့်အပိုင်း --%>
                        <c:if test="${not empty errorMsg}">
                            <div class="alert alert-danger text-center" role="alert">
                                ${errorMsg}
                            </div>
                            <c:remove var="errorMsg" scope="session" />
                        </c:if>

                        <form action="login" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" id="email" name="email" 
                                       class="form-control" placeholder="enter email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" id="password" name="password" 
                                       class="form-control" placeholder="enter password" required>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary w-100">Login</button>
                                <p class="mt-3">Don't have an account? <a href="signup.jsp">Create one</a></p>
                            </div>
                           <!--  guestbutton -->
                           <div class="mt-3 text-center">
    								<a href="explore" class="btn btn-outline-secondary w-100">Continue as Guest</a>
							</div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>