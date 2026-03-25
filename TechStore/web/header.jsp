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
    <a href="home" class="logo">TechStore</a>

    <div class="search-bar-header">
        <form action="products" method="GET">
            <input type="text" name="keyword" placeholder="Bạn cần tìm gì?">
            <button type="submit">🔍</button>
        </form>
    </div>

    <div class="nav-links">
        <a href="home">🏠 Trang chủ</a>
        <a href="products">📦 Sản phẩm</a>
        <a href="cart">🛒 Giỏ hàng</a>

        <c:choose>
            <c:when test="${sessionScope.user == null}">
                <a href="login.jsp">🔑 Đăng nhập</a>
            </c:when>
            <c:otherwise>
                <c:if test="${sessionScope.user.role == 1}">
                    <a href="admin_dashboard.jsp" style="color: #ffcc00; font-weight: bold;">🛠 QL Sản phẩm</a>
                    <a href="admin/orders" style="color: #4ade80; font-weight: bold;">📦 QL Đơn hàng</a>
                    <a href="admin/users" style="color: #60a5fa; font-weight: bold;">👥 QL Người dùng</a>
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
                        <a href="profile.jsp">👤 Thông tin cá nhân</a>
                        <a href="change_password.jsp">🔒 Đổi mật khẩu</a>
                        <a href="logout">🚪 Đăng xuất</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>