<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Snippet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow p-4">
        <h2 class="text-primary mb-4">Edit Code Snippet</h2>
        <form action="edit-snippet" method="POST">
            <input type="hidden" name="id" value="${snippet.id}">
            
            <div class="mb-3">
                <label class="form-label fw-bold">Title</label>
                <input type="text" name="title" class="form-control" value="${snippet.title}" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Category</label>
                <select name="categoryId" class="form-control" required>
                    <option value="">-- Select Category --</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${cat.id == snippet.categoryId ? 'selected' : ''}>
                            ${cat.name}
                        </option>
                    </c:forEach>
                </select>
                <small class="text-muted">အရင်ရွေးထားသော Category: ${snippet.categoryName}</small>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Description</label>
                <textarea name="description" class="form-control" rows="3">${snippet.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Code Content</label>
                <textarea name="codeContent" class="form-control" rows="8" required>${snippet.codeContent}</textarea>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-warning px-4 fw-bold">Update Snippet</button>
                <a href="home" class="btn btn-secondary px-4">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html> --%>
<!-- with photo edit -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Snippet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow p-4">
        <h2 class="text-primary mb-4">Edit Code Snippet</h2>
        <form action="edit-snippet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${snippet.id}">
            
            <div class="row">
                <div class="col-md-8">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Title</label>
                        <input type="text" name="title" class="form-control" value="${snippet.title}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Category</label>
                        <select name="categoryId" class="form-control" required>
                            <option value="">-- Select Category --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${cat.id == snippet.categoryId ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-primary">Current Image</label>
                        <div class="border rounded p-2 text-center bg-white mb-2" style="height: 150px;">
                            <c:choose>
                                <c:when test="${not empty snippet.imagePath}">
                                    <img src="${snippet.imagePath}" class="img-fluid rounded h-100">
                                </c:when>
                                <c:otherwise>
                                    <div class="py-4 text-muted small">No Image</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <input type="file" name="image" class="form-control form-control-sm" accept="image/*">
                        <small class="text-muted">ပုံအသစ်လဲလိုပါက ရွေးချယ်ပါ</small>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Description</label>
                <textarea name="description" class="form-control" rows="3">${snippet.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Code Content</label>
                <textarea name="codeContent" class="form-control" rows="8" required>${snippet.codeContent}</textarea>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-warning px-4 fw-bold">Update Snippet</button>
                <a href="home" class="btn btn-secondary px-4">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>