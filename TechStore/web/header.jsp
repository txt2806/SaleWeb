<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.user-menu {
    position: relative;
    display: inline-block;
    vertical-align: middle;
    margin-left: 15px;
}
.user-menu-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    background: none;
    border: none;
    color: white;
    font-size: 15px;
    font-weight: 500;
    padding: 0;
}
.user-menu-btn img {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #555;
}
.dropdown-content {
    display: none;
    position: absolute;
    right: 0;
    top: 100%;
    background-color: #fff;
    min-width: 180px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.15);
    z-index: 1000;
    border-radius: 8px;
    overflow: hidden;
}
.dropdown-content a {
    color: #333 !important;
    padding: 12px 16px !important;
    text-decoration: none;
    display: block !important;
    text-align: left;
    font-weight: normal !important;
    border-bottom: 1px solid #f0f0f0;
}
.dropdown-content a:hover {
    background-color: #f8f9fa;
    color: #e67e22 !important;
}
.user-menu:hover .dropdown-content {
    display: block;
}
</style>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="logo">TechStore</a>

    <div class="search-bar-header">
        <form action="${pageContext.request.contextPath}/products" method="GET" autocomplete="off">
            <input type="text" name="keyword" id="searchInput" placeholder="Bạn cần tìm gì?">
            <button type="submit">🔍</button>
        </form>
        <div class="search-suggestions" id="searchSuggestions"></div>
    </div>

    <script>
    (function() {
        var input = document.getElementById('searchInput');
        var sugBox = document.getElementById('searchSuggestions');
        var debounceTimer = null;
        var activeIndex = -1;

        function formatPrice(price) {
            return Math.round(price).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + 'đ';
        }

        input.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            var keyword = this.value.trim();
            if (keyword.length < 1) {
                sugBox.innerHTML = '';
                sugBox.style.display = 'none';
                activeIndex = -1;
                return;
            }
            debounceTimer = setTimeout(function() {
                fetch('${pageContext.request.contextPath}/search-suggest?keyword=' + encodeURIComponent(keyword))
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.length === 0) {
                            sugBox.innerHTML = '<div class="suggest-empty">Không tìm thấy sản phẩm nào</div>';
                            sugBox.style.display = 'block';
                            activeIndex = -1;
                            return;
                        }
                        var html = '';
                        data.forEach(function(p) {
                            var img = p.image || 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png';
                            html += '<a href="${pageContext.request.contextPath}/detail?id=' + p.id + '" class="suggest-item">';
                            html += '<img src="' + img + '" alt="">';
                            html += '<div class="suggest-info">';
                            html += '<div class="suggest-name">' + p.name + '</div>';
                            html += '<div class="suggest-price">' + formatPrice(p.price) + '</div>';
                            html += '</div></a>';
                        });
                        sugBox.innerHTML = html;
                        sugBox.style.display = 'block';
                        activeIndex = -1;
                    })
                    .catch(function() {
                        sugBox.style.display = 'none';
                    });
            }, 250);
        });

        input.addEventListener('keydown', function(e) {
            var items = sugBox.querySelectorAll('.suggest-item');
            if (!items.length) return;
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                activeIndex = (activeIndex + 1) % items.length;
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                activeIndex = (activeIndex - 1 + items.length) % items.length;
            } else if (e.key === 'Enter' && activeIndex >= 0) {
                e.preventDefault();
                items[activeIndex].click();
                return;
            }
            items.forEach(function(el, i) {
                el.classList.toggle('active', i === activeIndex);
            });
        });

        document.addEventListener('click', function(e) {
            if (!e.target.closest('.search-bar-header')) {
                sugBox.style.display = 'none';
                activeIndex = -1;
            }
        });

        input.addEventListener('focus', function() {
            if (sugBox.innerHTML.trim()) sugBox.style.display = 'block';
        });
    })();
    </script>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">🏠 Trang chủ</a>
        <a href="${pageContext.request.contextPath}/products">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>

        <c:choose>
            <c:when test="${sessionScope.user == null}">
                <a href="${pageContext.request.contextPath}/login.jsp">🔑 Đăng nhập</a>
            </c:when>
            <c:otherwise>
                <c:if test="${sessionScope.user.role == 1}">
                    <a href="${pageContext.request.contextPath}/admin_dashboard.jsp" style="color: #ffcc00; font-weight: bold;">🛠 QL Sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" style="color: #4ade80; font-weight: bold;">📦 QL Đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/admin/users" style="color: #60a5fa; font-weight: bold;">👥 QL Người dùng</a>
                </c:if>

                <div class="user-menu">
                    <button class="user-menu-btn">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatar}">
                                <img src="${sessionScope.user.avatar}" alt="Avatar" onerror="this.onerror=null;this.src='https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random';">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random" alt="Avatar">
                            </c:otherwise>
                        </c:choose>
                        <span>${sessionScope.user.username} ▼</span>
                    </button>
                    <div class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/profile.jsp">👤 Thông tin cá nhân</a>
                        <a href="${pageContext.request.contextPath}/change_password.jsp">🔒 Đổi mật khẩu</a>
                        <a href="${pageContext.request.contextPath}/logout">🚪 Đăng xuất</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>