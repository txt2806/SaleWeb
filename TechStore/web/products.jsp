<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sản phẩm - TechStore</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="container">
            <h2 class="title">Danh sách sản phẩm</h2>

            <div class="filter-section" style="display: flex; justify-content: space-between; margin-bottom: 30px; align-items: center; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">

                <div class="category-menu" style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/products" class="btn" 
                       style="text-decoration: none; margin-top: 0; background: ${empty activeCategory && empty keyword ? '#1e40af' : '#3b82f6'};">
                        Tất cả
                    </a>

                    <c:forEach items="${categories}" var="c">
                        <a href="${pageContext.request.contextPath}/products?category_id=${c.id}" class="btn" 
                           style="text-decoration: none; margin-top: 0; background: ${activeCategory == c.id ? '#1e40af' : '#3b82f6'};">
                            ${c.name}
                        </a>
                    </c:forEach>
                </div>

                <div class="search-box">
                    <form action="${pageContext.request.contextPath}/products" method="GET" style="display: flex; gap: 5px; margin: 0;">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Nhập tên sản phẩm..." 
                               style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 6px; width: 250px; outline: none;">
                        <button type="submit" class="btn" style="margin-top: 0; height: 100%;">Tìm kiếm</button>
                    </form>
                </div>
            </div>
            <div class="product-grid">

                <c:choose>
                    <c:when test="${empty data}">
                        <div style="grid-column: 1 / -1; text-align: center; padding: 50px; background: white; border-radius: 8px;">
                            <img src="https://cdn-icons-png.flaticon.com/512/2748/2748558.png" width="100" style="margin-bottom: 15px; opacity: 0.5;">
                            <h3 style="color: #666;">Không tìm thấy sản phẩm nào phù hợp!</h3>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach items="${data}" var="p">
                            <div class="product-card">

                                <a href="${pageContext.request.contextPath}/detail?id=${p.id}">
                                    <img src="${not empty p.image ? p.image : 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'}" alt="${p.name}">
                                </a>

                                <h3 class="product-name">${p.name}</h3>
                                <p class="price">${p.price}đ</p>

                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin-top: 15px;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn" style="width: 100%;">Thêm vào giỏ</button>
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