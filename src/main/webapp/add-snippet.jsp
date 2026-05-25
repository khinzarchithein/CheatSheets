<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Snippet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow p-4">
        <h2 class="text-primary mb-4">Add New Code Snippet</h2>
        
       <%--  <form action="add-snippet" method="POST" enctype="multipart/form-data">
            <div class="mb-3">
                <label class="form-label fw-bold">Title</label>
                <input type="text" name="title" class="form-control" placeholder="Snippet ခေါင်းစဉ်ရိုက်ပါ" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Category</label>
                <select name="categoryId" class="form-select" required>
                    <option value="" selected disabled>-- Select a Category --</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}">${cat.name}</option>
                    </c:forEach>
                </select>
                <div class="form-text text-muted">Category တစ်ခုခုကို မဖြစ်မနေ ရွေးချယ်ပေးပါ။</div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Description</label>
                <textarea name="description" class="form-control" placeholder="ဒီ code က ဘာလုပ်ပေးတာလဲဆိုတာ ရှင်းပြပါ..." rows="3"></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Code Content</label>
                <textarea name="codeContent" class="form-control" rows="8" placeholder="Source code တွေကို ဒီမှာ ထည့်ပါ" required></textarea>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary px-4 fw-bold">Save Snippet</button>
                <a href="home" class="btn btn-secondary px-4">Back to Home</a>
            </div>
        </form> --%>
        <form action="add-snippet" method="POST" enctype="multipart/form-data" class="shadow p-4 rounded bg-white">
    <div class="mb-3">
        <label class="form-label fw-bold">Title</label>
        <input type="text" name="title" class="form-control" placeholder="Snippet ခေါင်းစဉ်ရိုက်ပါ" required>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Category</label>
        <select name="categoryId" class="form-select" required>
            <option value="" selected disabled>-- Select a Category --</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.id}">${cat.name}</option>
            </c:forEach>
        </select>
        <div class="form-text text-muted">Category တစ်ခုခုကို မဖြစ်မနေ ရွေးချယ်ပေးပါ။</div>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Description</label>
        <textarea name="description" class="form-control" placeholder="ဒီ code က ဘာလုပ်ပေးတာလဲဆိုတာ ရှင်းပြပါ..." rows="3"></textarea>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Code Content</label>
        <textarea name="codeContent" class="form-control" rows="8" placeholder="Source code တွေကို ဒီမှာ ထည့်ပါ" required></textarea>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold text-primary">
            <i class="bi bi-image"></i> Preview Image (Optional)
        </label>
        <input type="file" name="image" class="form-control" accept="image/*">
        <div class="form-text small">UI Screenshot သို့မဟုတ် Diagram လေးတွေ ထည့်သွင်းနိုင်ပါတယ်။</div>
    </div>

    <div class="mt-4 pt-3 border-top">
        <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">
            <i class="bi bi-cloud-arrow-up"></i> Save Snippet
        </button>
        <a href="home" class="btn btn-outline-secondary px-4">Back to Home</a>
    </div>
</form>
    </div>
</div>
</body>
</html>