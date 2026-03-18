<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang chủ - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="hero">
            <div class="container" style="display: flex; flex-direction: column; align-items: center;">
                <h1>Bùng Nổ Công Nghệ</h1>
                <p>Khám phá laptop, bàn phím và phụ kiện gaming đỉnh cao với giá tốt nhất.</p>
                <a href="products" class="btn">Mua sắm ngay</a>
            </div>
        </div>

        <div class="container">
            <h2 class="title">Danh mục nổi bật</h2>
            <div class="category">
                <a href="products?category_id=1" class="cat-card">💻 Laptop</a>
                <a href="products?category_id=2" class="cat-card">🖥 PC Máy Bộ</a>
                <a href="products?category_id=3" class="cat-card">⌨ Bàn phím</a>
                <a href="products?category_id=4" class="cat-card">🖱 Chuột</a>
            </div>

            <h2 class="title" style="margin-top: 50px;">Sản phẩm nổi bật</h2>
            <div class="product-grid">
                <c:choose>
                    <c:when test="${empty featuredProducts}">
                        <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666; width: 100%;">
                            Đang cập nhật sản phẩm...
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${featuredProducts}" var="p">
                            <div class="product-card">
                                <a href="detail?id=${p.id}">
                                    <img src="${not empty p.image ? p.image : 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'}" alt="${p.name}">
                                </a>
                                <h3 class="product-name">${p.name}</h3>
                                <p class="price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</p>

                                <form action="cart" method="POST" style="margin-top: auto;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button class="btn" style="width: 100%;">Mua ngay</button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>