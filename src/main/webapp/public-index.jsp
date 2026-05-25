<!-- comment section -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Explore Cheatsheets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet" />
    
    <style>
        :root {
            --primary-dark: #1a3a5f;
            --accent-gold: #ffd700;
            --soft-bg: #f4f7f9;
        }

        body { background-color: var(--soft-bg); font-family: 'Segoe UI', system-ui, sans-serif; }

        .hero-area {
            background: linear-gradient(135deg, var(--primary-dark) 0%, #2c5282 100%);
            color: white;
            padding: 80px 0 100px;
            border-radius: 0 0 50px 50px;
            margin-bottom: -50px;
            position: relative;
        }

        .user-welcome-nav {
            position: absolute;
            top: 20px;
            right: 30px;
            z-index: 10;
        }

        .search-box-wrapper {
            max-width: 750px;
            margin: 0 auto;
            background: white;
            padding: 10px;
            border-radius: 100px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .search-box-wrapper .form-control {
            border: none;
            padding-left: 25px;
            background: transparent;
        }
        .search-box-wrapper .form-control:focus { box-shadow: none; }
        .search-btn {
            background-color: var(--primary-dark);
            color: white;
            border-radius: 100px !important;
            padding: 10px 30px;
            transition: 0.3s;
        }
        .search-btn:hover { background-color: #2c5282; color: var(--accent-gold); }

        .category-card {
            background: white;
            border: 1px solid rgba(0,0,0,0.05);
            border-radius: 20px;
            padding: 35px 20px;
            text-align: center;
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-decoration: none;
            display: block;
            height: 100%;
        }
        .category-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            border-color: var(--primary-dark);
        }
        .category-icon-circle {
            width: 80px;
            height: 80px;
            background: var(--soft-bg);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2.2rem;
            color: var(--primary-dark);
            transition: 0.3s;
        }
        .category-card:hover .category-icon-circle {
            background: var(--primary-dark);
            color: var(--accent-gold);
        }

        .snip-card {
            border: none; border-radius: 15px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: 0.3s;
        }
        .snip-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        pre[class*="language-"] {
            margin: 0 !important;
            border-radius: 10px !important;
            background: #1e1e1e !important;
            font-size: 0.85rem !important;
        }
        
        .cursor-pointer { cursor: pointer; }
        .star-icon { transition: 0.2s; }
        .star-icon:hover { transform: scale(1.2); }
    </style>
</head>
<body>

<div class="user-welcome-nav d-flex gap-2">
			<c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="dropdown">
                <button class="btn btn-light rounded-pill shadow-sm dropdown-toggle px-3" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.username}
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <li><a class="dropdown-item" href="index.jsp"><i class="bi bi-speedometer2 me-2"></i> Admin Dashboard</a></li>
                    </c:if>
                 
                    <li><a class="dropdown-item text-danger" href="logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                </ul>
            </div>
        </c:when>
        <c:otherwise>
            <a href="login.jsp" class="btn btn-outline-light rounded-pill px-4">Login</a>
            <a href="signup.jsp" class="btn btn-warning rounded-pill px-4 fw-bold shadow-sm">Sign Up</a>
        </c:otherwise>
    </c:choose>
</div>

<div class="hero-area text-center">
    <div class="container">
        <h1 class="display-3 fw-bold mb-3">CheatSheets <span style="color: var(--accent-gold);">Collection</span></h1>
        <p class="lead opacity-75 mb-5">Discover <strong>High-Quality</strong> Code Snippets in one place.</p>
        
        <div class="search-box-wrapper mb-4">
            <form action="explore" method="GET" class="d-flex align-items-center">
                <i class="bi bi-search ms-3 text-muted fs-5"></i>
                <input type="text" name="search" class="form-control form-control-lg" placeholder="Search for snippets..." value="${param.search}">
                <button class="btn search-btn fw-bold shadow-sm" type="submit">Search</button>
                <c:if test="${not empty param.search}">
                    <a href="explore" class="btn text-muted px-3"><i class="bi bi-x-lg"></i></a>
                </c:if>
            </form>
        </div>
    </div>
</div>

<div class="container py-5 mt-5">
    
    <c:if test="${not empty sessionScope.user}">
        <div class="d-flex justify-content-center gap-3 mb-5">
            <a href="add-snippet" class="btn btn-success rounded-pill px-4 py-2 shadow-sm fw-bold">
                <i class="bi bi-plus-circle me-1"></i> Add Your Snippet
            </a>
            <a href="saved-list" class="btn btn-primary rounded-pill px-4 py-2 shadow-sm fw-bold">
                <i class="bi bi-bookmark-heart me-1"></i> My Saved
            </a>
            <a href="explore?filter=top" class="btn btn-warning rounded-pill px-4 py-2 shadow-sm fw-bold">
                <i class="bi bi-star-fill me-1"></i> Top Rated Snippets
            </a>
        </div>
    </c:if>

    <%-- Category Cards --%>
    <c:if test="${empty param.category && empty param.search && empty param.filter}">
        <div class="row g-4">
            <c:forEach var="cat" items="${categories}">
                <div class="col-md-4">
                    <a href="explore?category=${cat.id}" class="category-card">
                        <div class="category-icon-circle">
                            <c:choose>
                                <c:when test="${cat.name == 'Programming'}"><i class="bi bi-code-slash"></i></c:when>
                                <c:when test="${cat.name == 'Software & Tools'}"><i class="bi bi-pc-display"></i></c:when>
                                <c:when test="${cat.name == 'Web Development'}"><i class="bi bi-globe"></i></c:when>
                                <c:otherwise><i class="bi bi-folder-fill"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h4 class="fw-bold text-dark mb-2">${cat.name}</h4>
                        <span class="text-muted small">Browse all cheatsheets</span>
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:if>
					<%-- Results Area --%>
    <c:if test="${not empty param.category or not empty param.search or not empty param.filter}">
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <h2 class="fw-bold" style="color: var(--primary-dark);">
                <c:choose>
                    <%-- ပြင်ဆင်ချက် ၁: class ကို test သို့ ပြောင်းလဲထားပါသည် --%>
                    <c:when test="${param.filter == 'top'}">Top Rated Snippets</c:when>
                    <c:otherwise>Results</c:otherwise>
                </c:choose>
            </h2>
            <a href="explore" class="btn btn-light rounded-pill shadow-sm border px-3">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>

        <div class="row">
            <c:if test="${empty snippets}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-inbox text-muted display-1"></i>
                    <p class="text-muted fs-4">No snippets found.</p>
                </div>
            </c:if>
          
            <c:forEach var="item" items="${snippets}">
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card snip-card h-100 shadow-sm border-0">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill">${item.categoryName}</span>
                                <c:if test="${not empty sessionScope.user}">
                                    <%-- ပြင်ဆင်ချက် ၂: item.isIsSaved() ကို ခေါ်ဆိုနိုင်ရန် item.isIsSaved() တိုက်ရိုက် ရေးသားထားပါသည် --%>
                                    <i class="bi ${item.isIsSaved() ? 'bi-bookmark-fill text-primary' : 'bi-bookmark'} fs-5 cursor-pointer" 
                                       id="save-icon-${item.id}" onclick="toggleSave(${item.id})"></i>
                                </c:if>
                            </div>

                            <h4 class="fw-bold text-dark mb-1">${item.title}</h4>
                            <div class="mb-2">
                                <span class="text-warning fw-bold small"><i class="bi bi-star-fill"></i> ${item.averageRating}</span>
                                <small class="text-muted"> / 5.0</small>
                            </div>

                            <p class="text-secondary small mb-3 text-truncate-2">${item.description}</p>
                            
                            <c:if test="${not empty item.imagePath}">
                                <div class="mb-3 text-center">
                                    <img src="${pageContext.request.contextPath}/${item.imagePath}" class="img-fluid rounded border shadow-sm" 
                                         style="max-height: 180px; width: 100%; object-fit: cover; cursor: zoom-in;" 
                                         onclick="window.open(this.src)">
                                </div>
                            </c:if>

                            <div class="position-relative mb-3">
                                <pre class="language-java"><code id="snippet-${item.id}"><c:out value="${item.codeContent}"/></code></pre>
                                <button class="btn btn-sm btn-light position-absolute top-0 end-0 m-2 opacity-50" 
                                        onclick="copyToClipboard('snippet-${item.id}', this)">
                                    <i class="bi bi-clipboard"></i>
                                </button>
                            </div>

                            <div class="bg-light p-3 rounded-3 text-center shadow-sm mb-3">
                                <c:choose>
                                	 <c:when test="${item.userRating > 0}">
                                        <p class="text-success mb-1 fw-bold" style="font-size: 0.75rem;">
                                            Your Rating: 
                                            <span class="text-warning">
                                                <c:forEach begin="1" end="${item.userRating}">★</c:forEach>
                                            </span>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="text-muted d-block mb-1" style="font-size: 0.7rem; font-weight: 600;">Tap to rate</small>
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

                            <div class="border-top pt-2">
                                <button class="btn btn-link btn-sm text-decoration-none text-muted p-0 d-flex align-items-center gap-1 fw-bold" 
                                        type="button" data-bs-toggle="collapse" data-bs-target="#commentCollapse-${item.id}" 
                                        onclick="loadComments(${item.id})">
                                    <i class="bi bi-chat-left-text-fill text-primary"></i> View/Write Comments
                                </button>
                                
                                <div class="collapse mt-2" id="commentCollapse-${item.id}">
                                    <div class="card card-body bg-light border-0 p-2 rounded-3" style="font-size: 0.85rem;">
                                        <div id="commentList-${item.id}" class="pe-1" style="max-height: 160px; overflow-y: auto;">
                                            <small class="text-muted d-block text-center py-2">Loading comments...</small>
                                        </div>

                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <div class="input-group input-group-sm mt-2 border rounded-3 bg-white p-1">
                                                    <input type="text" id="commentInput-${item.id}" class="form-control border-0 bg-transparent" placeholder="Write a comment...">
                                                    <button class="btn btn-primary rounded-3 px-3 fw-bold" type="button" onclick="submitComment(${item.id})">Post</button>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <small class="text-muted d-block text-center mt-2 border-top pt-1">
                                                    Please <a href="login.jsp" class="text-primary text-decoration-none fw-bold">Login</a> to comment.
												</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                        </div>
                        
                        <div class="card-footer bg-white border-0 pt-0 pb-3">
                            <c:if test="${sessionScope.user.role == 'admin' or (not empty sessionScope.user && sessionScope.user.id == item.userId)}">
                                <div class="d-flex gap-2">
                                    <a href="edit-snippet?id=${item.id}" class="btn btn-sm btn-outline-primary w-50 rounded-pill">Edit</a>
                                    <a href="delete-snippet?id=${item.id}" class="btn btn-sm btn-outline-danger w-50 rounded-pill" onclick="return confirm('Are you sure?')">Delete</a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js"></script>

 <script>
 // Reply ပြန်ရန် လမ်းကြောင်းကို မှတ်သားထားမည့် Global Object
let activeParentCommentId = {};

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
        }
    });
}

function submitRating(snippetId, ratingValue) {
    var isUserLoggedIn = ${not empty sessionScope.user}; 
    
    if (!isUserLoggedIn) {
        alert('Please login to rate!'); 
        return;
    }
    
    fetch('rate-snippet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'snippetId=' + snippetId + '&rating=' + ratingValue
    })
    .then(response => response.text())
    .then(data => {
        if (data.trim() === "success") { location.reload(); }
    });
}

function copyToClipboard(elementId, btn) {
    var codeText = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(codeText).then(function() {
        var icon = btn.innerHTML;
        btn.innerHTML = '<i class="bi bi-check text-success"></i>';
        setTimeout(function() { btn.innerHTML = icon; }, 2000);
    });
}

// ရွေးချယ်ထားသော Comment ကို Reply ပြန်ရန် သတ်မှတ်ပေးသည့် Function
function setReplyTarget(snippetId, commentId, username) {
    activeParentCommentId[snippetId] = commentId;
    const input = document.getElementById('commentInput-' + snippetId);
    if(input) {
        input.placeholder = "Replying to @" + username + "...";
        input.focus();
    }
}

// Comment နှင့် Reply များကို Dynamic ဆွဲထုတ်ပြသမည့် Function
// Comment နှင့် Reply များကို Dynamic အစီအစဉ်တကျ ဆွဲထုတ်ပြသမည့် Function
function loadComments(snippetId) {
    const listContainer = document.getElementById('commentList-' + snippetId);
    if (!listContainer) return;
    
    fetch('comment?snippetId=' + snippetId)
    .then(response => response.json())
    .then(data => {
        listContainer.innerHTML = '';
        if (data.length === 0) {
            listContainer.innerHTML = '<small class="text-muted d-block text-center py-2">No comments yet. Be the first!</small>';
            return;
        }

        const mainCommentsMap = {};
        const repliesArray = [];

        // ၁။ လာသမျှ Data များကို ပင်မ (Main) နှင့် ပြန်စာ (Reply) ခွဲထုတ်ခြင်း
        data.forEach(comment => {
            if (comment.parentCommentId === 0) {
                mainCommentsMap[comment.id] = comment;
                comment.replies = []; // Reply များ စုထည့်ရန် Array ကြိုဆောက်ခြင်း
            } else {
                repliesArray.push(comment);
            }
        });

        // ၂။ Reply များကို သက်ဆိုင်ရာ ပင်မ Comment အောက်သို့ ကွက်တိ ထည့်သွင်းခြင်း
        repliesArray.forEach(reply => {
            if (mainCommentsMap[reply.parentCommentId]) {
                mainCommentsMap[reply.parentCommentId].replies.push(reply);
            }
        });

        // ၃။ UI ပေါ်တွင် Badge များမပါဘဲ အစီအစဉ်တကျ Thread ပုံစံအတိုင်း ပတ်ထုတ်ခြင်း
        Object.values(mainCommentsMap).forEach(mainComment => {
            
            // --- (က) ပင်မ Comment (ဥပမာ- mama သို့မဟုတ် admin) ---
            const mainDiv = document.createElement('div');
            mainDiv.className = 'mb-2 pb-1 bg-white p-2 rounded-3 shadow-sm text-start';
            
            let replyBtn = '';
            var isUserLoggedIn = ${not empty sessionScope.user};
            if (isUserLoggedIn) {
                replyBtn = '<button class="btn btn-sm btn-link text-primary p-0 ms-2" style="font-size: 0.75rem; text-decoration: none;" onclick="setReplyTarget(' + snippetId + ', ' + mainComment.id + ', \'' + mainComment.username + '\')"><i class="bi bi-reply-fill"></i> Reply</button>';
            }

            mainDiv.innerHTML = 
                '<div class="d-flex justify-content-between align-items-center mb-1">' +
                    '<strong class="text-dark" style="font-size: 0.8rem;">' +
                        '<i class="bi bi-person-fill text-secondary"></i> ' + mainComment.username +
                    '</strong>' +
                    '<span class="text-muted" style="font-size: 0.65rem;">' + mainComment.time + '</span>' +
                '</div>' +
                '<p class="mb-0 text-secondary" style="font-size: 0.8rem; word-break: break-all;">' + mainComment.text + '</p>' +
                '<div class="text-end">' + replyBtn + '</div>' +
                '' +
                '<div id="subRepliesArea-' + mainComment.id + '"></div>';
                
            listContainer.appendChild(mainDiv);

            // --- (ခ) ပင်မ Comment အောက်၌ ၎င်း၏ Reply များကို ကပ်လျက် ပတ်ထုတ်ခြင်း (ဥပမာ- nyinyi) ---
            const subRepliesArea = document.getElementById('subRepliesArea-' + mainComment.id);
            mainComment.replies.forEach(replyComment => {
                const replyDiv = document.createElement('div');
                // Reply ဖြစ်သဖြင့် Margin ကို ညာဘက်သို့ ရွှေ့ပြီး အပြာရောင် Border လိုင်းလေး ထည့်ပေးထားပါသည်
                replyDiv.className = 'mt-2 mb-2 pb-1 bg-light p-2 rounded-3 shadow-sm text-start border-start border-primary border-3';
                replyDiv.style.marginLeft = '30px';
                
                replyDiv.innerHTML = 
                    '<div class="d-flex justify-content-between align-items-center mb-1">' +
                        '<strong class="text-dark" style="font-size: 0.8rem;">' +
						 '<i class="bi bi-person-fill text-secondary"></i> ' + replyComment.username +
                        '</strong>' +
                        '<span class="text-muted" style="font-size: 0.65rem;">' + replyComment.time + '</span>' +
                    '</div>' +
                    '<p class="mb-0 text-secondary" style="font-size: 0.8rem; word-break: break-all;">' + replyComment.text + '</p>';
                
                if (subRepliesArea) {
                    subRepliesArea.appendChild(replyDiv);
                }
            });
        });

        listContainer.scrollTop = listContainer.scrollHeight;
    }).catch(err => {
        listContainer.innerHTML = '<small class="text-danger d-block text-center py-2">Failed to load comments.</small>';
    });
}
// Comment သို့မဟုတ် Reply ကို Server ထံ ပေးပို့သိမ်းဆည်းမည့် Function
function submitComment(snippetId) {
    const input = document.getElementById('commentInput-' + snippetId);
    if (!input) return;
    
    const text = input.value.trim();
    if (text === '') return;

    // ပြင်ဆင်ချက်: အကယ်၍ activeParentCommentId ထဲမှာ null/undefined ဖြစ်နေရင် သေချာပေါက် 0 (ပင်မ Comment) လို့ သတ်မှတ်ပေးလိုက်ပါတယ်
    let parentId = 0;
    if (activeParentCommentId && activeParentCommentId[snippetId]) {
        parentId = activeParentCommentId[snippetId];
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
            
            // ပြင်ဆင်ချက်: Comment တင်ပြီးရင် Target ကို 0 ပြန်လုပ်ပေးဖို့ လိုအပ်ပါတယ်
            if (activeParentCommentId) {
                activeParentCommentId[snippetId] = 0;
            }
            
            loadComments(snippetId);
        } else if (data.trim() === "login_required") {
            alert("Please login first!");
            window.location.href = "login.jsp";
        } else {
            alert("Something went wrong!");
        }
    }).catch(err => {
        alert("Server communication error!");
    });
} 
 
</script>
</body>
</html>