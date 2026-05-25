<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Saved Snippets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; border-radius: 12px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .code-box { background: #282c34; color: #abb2bf; padding: 15px; border-radius: 8px; font-size: 0.85rem; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-bookmark-heart-fill"></i> My Saved Snippets</h2>
        <a href="explore" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Back to</a>
    </div>

    <div class="row">
        <c:if test="${empty snippets}">
            <div class="col-12 text-center py-5">
                <h4 class="text-muted">You haven't saved any snippets yet.</h4>
                <a href="explore" class="btn btn-primary mt-3">Explore Now</a>
            </div>
        </c:if>
 

        <c:forEach var="item" items="${snippets}">
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="badge bg-info text-dark">${item.categoryName}</span>
                            <i class="bi bi-bookmark-fill text-primary fs-5" style="cursor:pointer" onclick="toggleSave(${item.id})"></i>
                        </div>
                        <h5 class="card-title fw-bold">${item.title}</h5>
                        <div class="code-box mb-3">
                            <pre class="mb-0"><code><c:out value="${item.codeContent}"/></code></pre>
                        </div>
                        <small class="text-muted">Saved from: ${item.categoryName}</small>
                    </div>
                </div>
            </div>
        </c:forEach>
   
    </div>
</div>

<script>
// Toggle Save (Saved list ထဲကနေ Unsave လုပ်ရင် ပျောက်သွားအောင်)
function toggleSave(snippetId) {
    if(confirm("Remove from saved list?")) {
        fetch('save-snippet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'snippetId=' + snippetId
        })
        .then(() => location.reload());
    }
}
</script>
</body>
</html>
          
    </div>
</div>

<script>
// Toggle Save (Saved list ထဲကနေ Unsave လုပ်ရင် ပျောက်သွားအောင်)
function toggleSave(snippetId) {
    if(confirm("Remove from saved list?")) {
        fetch('save-snippet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'snippetId=' + snippetId
        })
        .then(() => location.reload());
    }
}
</script>
</body>
</html> --%>

<!-- savedlist with photo -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Saved Snippets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .snip-card { border: none; border-radius: 15px; transition: 0.3s; overflow: hidden; }
        .snip-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .code-box { background: #282c34; color: #abb2bf; padding: 15px; border-radius: 8px; font-size: 0.85rem; }
        .img-preview { height: 180px; object-fit: cover; width: 100%; cursor: zoom-in; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-bookmark-heart-fill"></i> My Saved Snippets</h2>
        <a href="explore" class="btn btn-outline-secondary rounded-pill px-4">
            <i class="bi bi-arrow-left"></i> Back to Explore
        </a>
    </div>
    
    
    <div class="row">
    <c:if test="${empty snippets}">
        <div class="col-12 text-center py-5">
            <i class="bi bi-bookmark-x text-muted display-1"></i>
            <h4 class="text-muted mt-3">သင် ဘာ snippet မှ မသိမ်းရသေးပါဘူး။</h4>
            <a href="explore" class="btn btn-primary mt-3 rounded-pill px-4">Explore Now</a>
        </div>
    </c:if>

   <c:forEach var="item" items="${snippets}">
    <div class="col-md-6 col-xxl-4 mb-4">
        <div class="card snip-card h-100 shadow-sm border-0 bg-white">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill" style="font-size: 0.7rem;">
                        ${item.categoryName}
                    </span>
                    <i class="bi bi-bookmark-fill text-primary fs-5" style="cursor:pointer" 
                       onclick="toggleSave(${item.id})" title="Remove from saved list"></i>
                </div>

                <h5 class="card-title fw-bold text-dark mb-1">${item.title}</h5>
                <p class="card-text text-secondary small mb-3 text-truncate-2">${item.description}</p>
                
                <c:if test="${not empty item.imagePath}">
                    <div class="mb-3 text-center">
                        <img src="${item.imagePath}" class="img-fluid rounded border shadow-sm" 
                             style="max-height: 200px; width: 100%; object-fit: cover; cursor: zoom-in;" 
                             onclick="window.open(this.src)">
                    </div>
                </c:if>

                <div class="code-box bg-dark p-3 rounded mb-3" style="max-height: 150px; overflow-y: auto;">
                    <pre class="mb-0 text-white" style="font-size: 0.8rem;"><code><c:out value="${item.codeContent}"/></code></pre>
                </div>

                <div class="mb-3">
                    <small class="text-muted">
                        <i class="bi bi-folder-check me-1"></i> Saved from: <strong>${item.categoryName}</strong>
                    </small>
                </div>
            </div>

            <%-- <div class="card-footer bg-white border-top-0 d-flex justify-content-between px-4 pb-3 pt-0">
                <a href="edit-snippet?id=${item.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold">
                    <i class="bi bi-pencil-square me-1"></i> EDIT
                </a>
                <a href="delete-snippet?id=${item.id}" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold" 
                   onclick="return confirm('သေချာပါသလား?')">
                    <i class="bi bi-trash me-1"></i> DELETE
                </a>
            </div> --%>
            <div class="card-footer bg-white border-top-0 d-flex justify-content-between px-4 pb-3 pt-0">
    
    <c:if test="${sessionScope.user.role == 'admin' or sessionScope.user.id == item.userId}">
        <a href="edit-snippet?id=${item.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold">
            <i class="bi bi-pencil-square me-1"></i> EDIT
        </a>
        <a href="delete-snippet?id=${item.id}" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold" 
           onclick="return confirm('Are you sure want to delete!')">
            <i class="bi bi-trash me-1"></i> DELETE
        </a>
    </c:if>

    <c:if test="${sessionScope.user.role != 'admin' and sessionScope.user.id != item.userId}">
        <span class="text-muted small align-self-center">
            <i class="bi bi-lock-fill"></i> Read Only
        </span>
    </c:if>
</div>
            
        </div>
    </div> 
</c:forEach>
</div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Toggle Save Function
function toggleSave(snippetId) {
    if(confirm("Remove this snippet from your saved list?")) {
        fetch('save-snippet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'snippetId=' + snippetId
        })
        .then(response => response.text())
        .then(data => {
            // Unsave လုပ်ပြီးတာနဲ့ list ထဲက ပျောက်သွားအောင် reload လုပ်မယ်
            location.reload();
        });
    }
}
</script>
</body>
</html>