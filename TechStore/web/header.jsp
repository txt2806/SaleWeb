<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


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
                    <a href="admin_dashboard.jsp" style="color: #ffcc00; font-weight: bold;">🛠 Quản lý</a>
                </c:if>

                <a href="logout">🚪 Thoát (${sessionScope.user.username})</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>