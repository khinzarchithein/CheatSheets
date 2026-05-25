<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Comments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7f9; font-family: 'Segoe UI', sans-serif; }
        .admin-header { background: #1a3a5f; color: white; padding: 20px 0; margin-bottom: 30px; }
        .table-card { background: white; border-radius: 15px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<div class="admin-header shadow-sm">
    <div class="container d-flex justify-content-between align-items-center">
        <h4><i class="bi bi-shield-lock-fill text-warning me-2"></i> Admin Panel - Comment Moderation</h4>
        <a href="explore" class="btn btn-outline-light btn-sm rounded-pill px-3"><i class="bi bi-globe"></i> View Site</a>
    </div>
</div>

<div class="container">
    <div class="card table-card p-4">
        <h5 class="fw-bold mb-4 text-dark"><i class="bi bi-chat-left-text text-primary me-2"></i> All User Comments & Replies</h5>
        
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width: 8%;">Type</th>
                        <th style="width: 15%;">User</th>
                        <th style="width: 45%;">Comment Text</th>
                        <th style="width: 20%;">Date & Time</th>
                        <th style="width: 12%;" class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty adminComments}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="bi bi-chat-square-dots display-4 d-block mb-2"></i> No comments found in system.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="comment" items="${adminComments}">
                                <tr id="comment-row-${comment.id}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${comment.parentCommentId > 0}">
                                                <span class="badge bg-secondary rounded-pill">Reply</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary rounded-pill">Main</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong class="text-dark"><i class="bi bi-person me-1 text-secondary"></i> ${comment.username}</strong>
                                    </td>
                                    <td>
                                        <p class="mb-0 text-secondary" style="max-width: 450px; word-break: break-all;">${comment.commentText}</p>
                                    </td>
                                    <td>
                                        <small class="text-muted"><i class="bi bi-clock me-1"></i> ${comment.createdAt.substring(0,16)}</small>
					 					</td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteComment(${comment.id})">
                                            <i class="bi bi-trash3-fill"></i> Delete
                                        </button>
                                    </td>
                                </tr>
       				                     </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function deleteComment(commentId) {
    if (!confirm("Are you sure you want to delete this comment? If it is a main comment, all its replies will be deleted too!")) {
        return;
    }
    
    fetch('admin-comments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'commentId=' + commentId
    })
    .then(response => response.text())
    .then(data => {
        if (data.trim() === "success") {
            const row = document.getElementById('comment-row-' + commentId);
            if (row) {
                row.style.transition = "all 0.4s ease";
                row.style.opacity = "0";
                setTimeout(() => { row.remove(); }, 400);
            }
        } else {
            alert("Failed to delete comment!");
        }
    }).catch(err => {
        alert("Server error occurred!");
    });
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>