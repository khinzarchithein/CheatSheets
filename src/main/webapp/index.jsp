<%--  <!--admin with commentmanage  -->
 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.cheatsheets.model.User" %>

<%
    User u = (User) session.getAttribute("user");
    if (u == null || !"admin".equalsIgnoreCase(u.getRole())) {
        response.sendRedirect("explore");
        return; 
    }
    if (request.getAttribute("snippets") == null) {
        response.sendRedirect("explore");
        return;
    }
%>

<!-- top rate test -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | CheatSheets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet" />
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-blue: #1a3a5f;
            --light-bg: #f4f7f9;
        }

        body { background-color: var(--light-bg); font-family: 'Segoe UI', sans-serif; overflow-x: hidden; }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--primary-blue);
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            z-index: 1000;
        }

        .sidebar-header { padding: 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .nav-link { 
            color: rgba(255,255,255,0.7); 
            padding: 12px 20px; 
            margin: 5px 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }
        .nav-link:hover, .nav-link.active { background: rgba(255,255,255,0.1); color: #ffd700; }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: 100vh;
        }

        .top-nav {
            background: white;
            padding: 15px 30px;
            margin: -30px -30px 30px -30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .snippet-card { 
            border: none; 
            border-radius: 15px; 
            transition: 0.3s; 
            background: white;
            overflow: hidden;
        }
        .snippet-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        pre[class*="language-"] {
            margin: 0 !important;
            border-radius: 10px !important;
            background: #282c34 !important;
            font-size: 0.85rem !important;
        }

        .stats-card {
            background: white; border-radius: 12px; padding: 20px;
            display: flex; align-items: center; gap: 15px;
            border-left: 5px solid var(--primary-blue);
        }

        .cursor-pointer { cursor: pointer; }
        .star-icon { transition: 0.2s; }
    </style>
</head>
<body>

<div class="sidebar d-none d-lg-block">
        <div class="sidebar-header">
            <h4 class="fw-bold"><i class="bi bi-code-square"></i> CHEATSHEETS</h4>
            <small class="text-white-50">Admin Panel v2.0</small>
        </div>
 
        <div class="mt-4">
    <a href="index.jsp" class="nav-link active"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="add-snippet" class="nav-link"><i class="bi bi-plus-circle"></i> Add New Snippet</a>
    <a href="admin-comments" class="nav-link"><i class="bi bi-chat-left-text"></i> Manage Comments</a>
    
    <a href="saved-list" class="nav-link"><i class="bi bi-bookmark-heart"></i> My Saved</a>
    <hr class="mx-3 text-white-50">
    <a href="logout" class="nav-link text-danger"><i class="bi bi-box-arrow-left"></i> Logout</a>
</div>
    </div>
    <div class="main-content">
        <div class="top-nav">
            <h5 class="mb-0 fw-bold text-muted">Welcome, ${sessionScope.user.username}</h5>
            <form action="explore" method="GET" class="d-flex gap-2 w-50">
                <div class="input-group">
                    <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
 <input type="text" name="search" class="form-control bg-light border-0" placeholder="Search..." value="${param.search}">
                    <button class="btn btn-dark" type="submit">Search</button>
                </div>
            </form>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stats-card shadow-sm">
                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary">
                        <i class="bi bi-file-earmark-code fs-3"></i>
                    </div>
                    <div>
                        <small class="text-muted d-block">Total Snippets</small>
                        <h4 class="fw-bold mb-0">${snippets.size()}</h4>
                    </div>
                     <a href="explore?filter=top" class="btn btn-warning rounded-pill px-3 shadow-sm">
                        <i class="bi bi-star-fill me-1"></i> Top Rated Snippets
                    </a>
                </div>
            </div>
            <div class="col-md-8 text-end">
                <div class="d-flex flex-wrap gap-2 justify-content-end">
                    <a href="explore" class="btn btn-sm btn-outline-secondary rounded-pill px-3">All Categories</a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="explore?category=${cat.id}" class="btn btn-sm btn-outline-dark rounded-pill px-3">${cat.name}</a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="row">
            <c:if test="${empty snippets}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-inbox text-muted display-1"></i>
                    <p class="text-muted fs-4">No snippets found.</p>
                </div>
            </c:if>
            
            <c:forEach var="item" items="${snippets}">
                <div class="col-md-6 col-xxl-4 mb-4"> 
                    <div class="card snippet-card h-100 shadow-sm border-0">
                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <div class="position-relative">
                                    <img src="${pageContext.request.contextPath}/${item.imagePath}" class="card-img-top" style="height: 180px; object-fit: cover;">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 180px;">
                                    <i class="bi bi-code-slash text-muted fs-1"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-info text-dark px-3 py-2 rounded-pill" style="font-size: 0.7rem;">${item.categoryName}</span>
                                ပြင်ဆင်လိုက်သည့်နေရာ: item.isSaved အစား item.isIsSaved() method ကို တိုက်ရိုက်ခေါ်ထားပါသည်
                                <i class="bi ${item.isIsSaved() ? 'bi-bookmark-fill text-primary' : 'bi-bookmark'} fs-5 cursor-pointer" 
                                   id="save-icon-${item.id}" 
                                   onclick="toggleSave(${item.id})"></i>
                            </div>

                            <h5 class="card-title fw-bold text-dark">${item.title}</h5>
                            <div class="mb-2">
                                <span class="text-warning fw-bold small"><i class="bi bi-star-fill"></i> ${item.averageRating}</span>
 									<small class="text-muted"> / 5.0</small>
                            </div>
                            <p class="card-text text-muted small mb-3 text-truncate-2">${item.description}</p>
                            <div class="mb-3">
                                <pre class="language-java"><code style="max-height: 120px; display: block; overflow-y: auto;"><c:out value="${item.codeContent}"/></code></pre>
                            </div>
                    
                            <div class="text-center border-top pt-3 bg-light rounded-3 p-2">
                                <c:choose>
                                    <c:when test="${item.userRating > 0}">
                                        <p class="text-success mb-1 fw-bold" style="font-size: 0.75rem;">
                                            Your Rating: <span class="text-warning">
                                                <c:forEach begin="1" end="${item.userRating}">★</c:forEach>
                                            </span>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="text-muted d-block mb-1" style="font-size: 0.65rem;">Tap to rate:</small>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="d-flex justify-content-center gap-1">
                                    <c:forEach begin="1" end="5" var="num">
                                        <i class="bi ${num <= item.userRating ? 'bi-star-fill text-warning' : 'bi-star text-secondary'} fs-4 cursor-pointer star-icon" 
                                           onclick="submitRating(${item.id}, ${num})"
                                           onmouseover="this.classList.replace('bi-star', 'bi-star-fill'); this.classList.add('text-warning')"
                                           onmouseout="if(${num} > ${item.userRating}) { this.classList.replace('bi-star-fill', 'bi-star'); this.classList.remove('text-warning'); }">
                                        </i>
                                    </c:forEach>
                                </div>
                            </div>
                            <!--admin comment  -->
                            <div class="mt-3 border-top pt-2">
    <a class="text-decoration-none text-muted small d-block mb-2 cursor-pointer" 
       onclick="toggleCommentBox(${item.id})">
        <i class="bi bi-chat-left-text me-1"></i> View/Write Comments
    </a>
    
    <div id="commentBoxArea-${item.id}" style="display: none;">
        <div id="commentList-${item.id}" class="overflow-auto bg-light p-2 rounded-3 mb-2" 
             style="max-height: 150px; font-size: 0.8rem;">
            <small class="text-muted d-block text-center">Loading comments...</small>
        </div>
        
        <div class="input-group input-group-sm">
            <input type="text" id="commentInput-${item.id}" class="form-control" placeholder="Write a comment...">
            <button class="btn btn-primary" type="button" onclick="submitAdminComment(${item.id})">Post</button>
        </div>
    </div>
</div>
                            
                            
                        </div>

                        <div class="card-footer bg-white border-top-0 d-flex justify-content-between px-3 pb-3">
                            <a href="edit-snippet?id=${item.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold">EDIT</a>
                            <a href="delete-snippet?id=${item.id}" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold" onclick="return confirm('Are you sure?')">DELETE</a>
                        </div>
                    </div>
                </div> 
            </c:forEach>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js"></script>

<script>
function toggleSave(snippetId) {
    const icon = document.getElementById('save-icon-' + snippetId);
    fetch('save-snippet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId
    })
    .then(response => response.text())
    .then(data => {
        if (data.trim() === "saved") {
            icon.classList.replace('bi-bookmark', 'bi-bookmark-fill');
            icon.classList.add('text-primary');
        } else if (data.trim() === "unsaved") {
            icon.classList.replace('bi-bookmark-fill', 'bi-bookmark');
            icon.classList.remove('text-primary');
        } else {
            // Error တစ်ခုခုဖြစ်ခဲ့ရင် page ကို reload လုပ်ပြီး status မှန်ကို ပြန်ယူပါမယ်
            location.reload();
        }
    });
}
function submitRating(snippetId, ratingValue) {
    fetch('rate-snippet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId + '&rating=' + ratingValue
    }).then(response => response.text()).then(data => {
        if (data.trim() === "success") { location.reload(); }
    });
}
</script>
</body>
</html> --%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.cheatsheets.model.User" %>

<%
    User u = (User) session.getAttribute("user");
    if (u == null || !"admin".equalsIgnoreCase(u.getRole())) {
        response.sendRedirect("explore");
        return; 
    }
    if (request.getAttribute("snippets") == null) {
        response.sendRedirect("explore");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | CheatSheets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet" />
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-blue: #1a3a5f;
            --light-bg: #f4f7f9;
        }

        body { background-color: var(--light-bg); font-family: 'Segoe UI', sans-serif; overflow-x: hidden; }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--primary-blue);
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            z-index: 1000;
        }

        .sidebar-header { padding: 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .nav-link { 
            color: rgba(255,255,255,0.7); 
            padding: 12px 20px; 
            margin: 5px 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }
        .nav-link:hover, .nav-link.active { background: rgba(255,255,255,0.1); color: #ffd700; }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: 100vh;
        }

        .top-nav {
            background: white;
            padding: 15px 30px;
            margin: -30px -30px 30px -30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .snippet-card { 
            border: none; 
            border-radius: 15px; 
            transition: 0.3s; 
            background: white;
            overflow: hidden;
        }
        .snippet-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        pre[class*="language-"] {
            margin: 0 !important;
            border-radius: 10px !important;
            background: #282c34 !important;
            font-size: 0.85rem !important;
        }

        .stats-card {
            background: white; border-radius: 12px; padding: 20px;
            display: flex; align-items: center; gap: 15px;
            border-left: 5px solid var(--primary-blue);
        }

        .cursor-pointer { cursor: pointer; }
        .star-icon { transition: 0.2s; }
    </style>
</head>
<body>
 	<div class="sidebar d-none d-lg-block">
    <div class="sidebar-header">
        <h4 class="fw-bold"><i class="bi bi-code-square"></i> CHEATSHEETS</h4>
        <small class="text-white-50">Admin Panel v2.0</small>
    </div>
    <div class="mt-4">
        <a href="index.jsp" class="nav-link active"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="add-snippet" class="nav-link"><i class="bi bi-plus-circle"></i> Add New Snippet</a>
        <a href="admin-comments" class="nav-link"><i class="bi bi-chat-left-text"></i> Manage Comments</a>
        <a href="saved-list" class="nav-link"><i class="bi bi-bookmark-heart"></i> My Saved</a>
        <hr class="mx-3 text-white-50">
        <a href="logout" class="nav-link text-danger"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
</div>

<div class="main-content">
    <div class="top-nav">
        <h5 class="mb-0 fw-bold text-muted">Welcome, ${sessionScope.user.username}</h5>
        <form action="explore" method="GET" class="d-flex gap-2 w-50">
            <div class="input-group">
                <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                <input type="text" name="search" class="form-control bg-light border-0" placeholder="Search..." value="${param.search}">
                <button class="btn btn-dark" type="submit">Search</button>
            </div>
        </form>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stats-card shadow-sm">
                <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary">
                    <i class="bi bi-file-earmark-code fs-3"></i>
                </div>
                <div>
                    <small class="text-muted d-block">Total Snippets</small>
                    <h4 class="fw-bold mb-0">${snippets.size()}</h4>
                </div>
                 <a href="explore?filter=top" class="btn btn-warning rounded-pill px-3 shadow-sm ms-auto">
                    <i class="bi bi-star-fill me-1"></i> Top Rated
                </a>
            </div>
        </div>
        <div class="col-md-8 text-end">
            <div class="d-flex flex-wrap gap-2 justify-content-end">
                <a href="explore" class="btn btn-sm btn-outline-secondary rounded-pill px-3">All Categories</a>
                <c:forEach var="cat" items="${categories}">
                    <a href="explore?category=${cat.id}" class="btn btn-sm btn-outline-dark rounded-pill px-3">${cat.name}</a>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="row">
        <c:if test="${empty snippets}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox text-muted display-1"></i>
                <p class="text-muted fs-4">No snippets found.</p>
            </div>
        </c:if>
        
        <c:forEach var="item" items="${snippets}">
            <div class="col-md-6 col-xxl-4 mb-4"> 
                <div class="card snippet-card h-100 shadow-sm border-0">
                    <c:choose>
                        <c:when test="${not empty item.imagePath}">
                            <div class="position-relative">
                                <img src="${pageContext.request.contextPath}/${item.imagePath}" class="card-img-top" style="height: 180px; object-fit: cover;">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 180px;">
                                <i class="bi bi-code-slash text-muted fs-1"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
				<div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge bg-info text-dark px-3 py-2 rounded-pill" style="font-size: 0.7rem;">${item.categoryName}</span>
                            <i class="bi ${item.isIsSaved() ? 'bi-bookmark-fill text-primary' : 'bi-bookmark'} fs-5 cursor-pointer" 
                               id="save-icon-${item.id}" 
                               onclick="toggleSave(${item.id})"></i>
                        </div>

                        <h5 class="card-title fw-bold text-dark">${item.title}</h5>
                        <div class="mb-2">
                            <span class="text-warning fw-bold small"><i class="bi bi-star-fill"></i> ${item.averageRating}</span>
                            <small class="text-muted"> / 5.0</small>
                        </div>
                        <p class="card-text text-muted small mb-3 text-truncate-2">${item.description}</p>
                        <div class="mb-3">
                            <pre class="language-java"><code style="max-height: 120px; display: block; overflow-y: auto;"><c:out value="${item.codeContent}"/></code></pre>
                        </div>
                
                        <div class="text-center border-top pt-3 bg-light rounded-3 p-2">
                            <c:choose>
                                    <c:when test="${item.userRating > 0}">
                                        <p class="text-success mb-1 fw-bold" style="font-size: 0.75rem;">
                                            Your Rating: <span class="text-warning">
                                                <c:forEach begin="1" end="${item.userRating}">★</c:forEach>
                                            </span>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="text-muted d-block mb-1" style="font-size: 0.65rem;">Tap to rate:</small>
                                    </c:otherwise>
                                </c:choose>
                            
                            <div class="d-flex justify-content-center gap-1">
                                <c:forEach begin="1" end="5" var="num">
                                    <i class="bi ${num <= item.userRating ? 'bi-star-fill text-warning' : 'bi-star text-secondary'} fs-4 cursor-pointer star-icon" 
                                       onclick="submitRating(${item.id}, ${num})"
                                       onmouseover="this.classList.replace('bi-star', 'bi-star-fill'); this.classList.add('text-warning')"
                                       onmouseout="if(${num} > ${item.userRating}) { this.classList.replace('bi-star-fill', 'bi-star'); this.classList.remove('text-warning'); }">
                                    </i>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div class="mt-3 border-top pt-2">
                            <a class="text-decoration-none text-muted small d-block mb-2 cursor-pointer" 
                               onclick="toggleCommentBox(${item.id})">
                                <i class="bi bi-chat-left-text me-1"></i> View/Write Comments
                            </a>
                            
                            <div id="commentBoxArea-${item.id}" style="display: none;">
                                <div id="commentList-${item.id}" class="overflow-auto bg-light p-2 rounded-3 mb-2" 
                                     style="max-height: 150px; font-size: 0.8rem;">
								<small class="text-muted d-block text-center">Loading comments...</small>
                                </div>
                                
                                <div class="input-group input-group-sm">
                                    <input type="text" id="commentInput-${item.id}" class="form-control" placeholder="Write a comment...">
                                    <button class="btn btn-primary" type="button" onclick="submitAdminComment(${item.id})">Post</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer bg-white border-top-0 d-flex justify-content-between px-3 pb-3">
                        <a href="edit-snippet?id=${item.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold">EDIT</a>
                        <a href="delete-snippet?id=${item.id}" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold" onclick="return confirm('Are you sure?')">DELETE</a>
                    </div>
                </div>
            </div> 
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js"></script>
 <script>
function toggleSave(snippetId) {
    const icon = document.getElementById('save-icon-' + snippetId);
    fetch('save-snippet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId
    })
    .then(response => response.text())
    .then(data => {
        if (data.trim() === "saved") {
            icon.classList.replace('bi-bookmark', 'bi-bookmark-fill');
            icon.classList.add('text-primary');
        } else if (data.trim() === "unsaved") {
            icon.classList.replace('bi-bookmark-fill', 'bi-bookmark');
            icon.classList.remove('text-primary');
        } else {
            location.reload();
        }
    });
}

function submitRating(snippetId, ratingValue) {
    fetch('rate-snippet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId + '&rating=' + ratingValue
    }).then(response => response.text()).then(data => {
        if (data.trim() === "success") { location.reload(); }
    });
}

let adminActiveParentCommentId = {};

function toggleCommentBox(snippetId) {
    const box = document.getElementById('commentBoxArea-' + snippetId);
    if (box.style.display === 'none') {
        box.style.display = 'block';
        adminActiveParentCommentId[snippetId] = 0; 
        loadAdminDashboardComments(snippetId);
    } else {
        box.style.display = 'none';
    }
}

function loadAdminDashboardComments(snippetId) {
    const listContainer = document.getElementById('commentList-' + snippetId);
    if (!listContainer) return;
    
    fetch('comment?snippetId=' + snippetId)
    .then(response => response.json())
    .then(data => {
        listContainer.innerHTML = '';
        if (data.length === 0) {
            listContainer.innerHTML = '<small class="text-muted d-block text-center py-2">No comments yet.</small>';
            return;
        }

        const mainCommentsMap = {};
        const repliesArray = [];

        data.forEach(comment => {
            if (comment.parentCommentId === 0) {
                mainCommentsMap[comment.id] = comment;
                comment.replies = []; 
            } else {
                repliesArray.push(comment);
            }
        });

        repliesArray.forEach(reply => {
            if (mainCommentsMap[reply.parentCommentId]) {
                mainCommentsMap[reply.parentCommentId].replies.push(reply);
            }
        });

        Object.values(mainCommentsMap).forEach(mainComment => {
            const mainDiv = document.createElement('div');
            mainDiv.className = 'mb-2 p-2 bg-white rounded shadow-sm';
            
            let mainBadgeHtml = '';
            if (mainComment.username.toLowerCase() === 'admin' || mainComment.userRole === 'admin') {
                mainBadgeHtml = ' <span class="badge bg-danger ms-1" style="font-size: 0.6rem; vertical-align: middle;">Admin</span>';
            } else {
                mainBadgeHtml = ' <span class="badge bg-success ms-1" style="font-size: 0.6rem; vertical-align: middle;">User</span>';
            }
            
            mainDiv.innerHTML = 
                '<div class="d-flex justify-content-between align-items-center mb-1" style="font-size: 0.75rem;">' +
                    '<strong class="text-dark"><i class="bi bi-person-fill text-secondary"></i> ' + mainComment.username + mainBadgeHtml + '</strong>' +
                    '<span class="text-muted" style="font-size: 0.6rem;">' + mainComment.time + '</span>' +
                '</div>' +
                '<p class="mb-1 text-secondary" style="font-size: 0.75rem; word-break: break-all;">' + mainComment.text + '</p>' +
                '<div class="text-end" id="adminReplyContainer-' + mainComment.id + '"></div>' +
                '<div id="subRepliesArea-' + mainComment.id + '"></div>';
                
            listContainer.appendChild(mainDiv);
				const btnContainer = document.getElementById('adminReplyContainer-' + mainComment.id);
            if (btnContainer) {
                const replyBtn = document.createElement('button');
                replyBtn.className = 'btn btn-sm btn-link text-danger p-0';
                replyBtn.style.fontSize = '0.7rem';
                replyBtn.style.textDecoration = 'none';
                replyBtn.innerHTML = '<i class="bi bi-reply-fill"></i> Reply';
                replyBtn.addEventListener('click', function() {
                    setAdminReplyTarget(snippetId, mainComment.id, mainComment.username);
                });
                btnContainer.appendChild(replyBtn);
            }

            const subRepliesArea = document.getElementById('subRepliesArea-' + mainComment.id);
            mainComment.replies.forEach(replyComment => {
                const replyDiv = document.createElement('div');
                replyDiv.className = 'mt-2 p-2 bg-light rounded border-start border-danger border-2';
                replyDiv.style.marginLeft = '20px'; 
                
                let replyBadgeHtml = '';
                if (replyComment.username.toLowerCase() === 'admin' || replyComment.userRole === 'admin') {
                    replyBadgeHtml = ' <span class="badge bg-danger ms-1" style="font-size: 0.6rem; vertical-align: middle;">Admin</span>';
                } else {
                    replyBadgeHtml = ' <span class="badge bg-success ms-1" style="font-size: 0.6rem; vertical-align: middle;">User</span>';
                }

                replyDiv.innerHTML = 
                    '<div class="d-flex justify-content-between align-items-center mb-1" style="font-size: 0.75rem;">' +
                        '<strong class="text-dark"><i class="bi bi-person-fill text-secondary"></i> ' + replyComment.username + replyBadgeHtml + '</strong>' +
                        '<span class="text-muted" style="font-size: 0.6rem;">' + replyComment.time + '</span>' +
                    '</div>' +
                    '<p class="mb-0 text-secondary" style="font-size: 0.75rem; word-break: break-all;">' + replyComment.text + '</p>';
                
                if (subRepliesArea) {
                    subRepliesArea.appendChild(replyDiv);
                }
            });
        });

        listContainer.scrollTop = listContainer.scrollHeight;
    }).catch(err => {
        console.error(err);
        listContainer.innerHTML = '<small class="text-danger d-block text-center py-2">Failed to load comments.</small>';
    });
}

function setAdminReplyTarget(snippetId, commentId, username) {
    adminActiveParentCommentId[snippetId] = commentId;
    const input = document.getElementById('commentInput-' + snippetId);
    if (input) {
        input.placeholder = "Reply to @" + username + "...";
        input.focus();
    }
}

function submitAdminComment(snippetId) {
    const input = document.getElementById('commentInput-' + snippetId);
    if (!input) return;
    
    const text = input.value.trim();
    if (text === '') return;

    let parentId = 0;
    if (adminActiveParentCommentId && adminActiveParentCommentId[snippetId]) {
        parentId = adminActiveParentCommentId[snippetId];
    }

    fetch('comment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId + '&commentText=' + encodeURIComponent(text) + '&parentCommentId=' + parentId
    })
    .then(response => response.text())
    .then(data => {
        if (data.trim() === "success") {
            input.value = '';
            input.placeholder = "Write a comment...";
            adminActiveParentCommentId[snippetId] = 0; 
            loadAdminDashboardComments(snippetId);
        } else {
            alert("Something went wrong!");
        }
    });
}
</script>
</body>
</html>