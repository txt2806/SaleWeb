<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sản phẩm - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .radio-label {
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 15px;
                color: #333;
                transition: 0.2s;
                padding: 8px 12px;
                border-radius: 6px;
                width: 100%;
            }
            .radio-label:hover {
                background: #fef2f2;
            }
            .radio-label input[type="radio"] {
                cursor: pointer;
                width: 16px;
                height: 16px;
                accent-color: #d70018;
            }
            .sidebar-filter {
                width: 250px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 1px 5px rgba(0,0,0,0.05);
            }
            .main-content {
                flex: 1;
            }
        </style>
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="container" style="display: flex; gap: 30px; margin-top: 30px; align-items: flex-start;">

            <div class="sidebar-filter">
                <h3 style="font-size: 18px; margin-bottom: 15px; color: #d70018; border-bottom: 2px solid #fecaca; padding-bottom: 10px;">LỌC SẢN PHẨM</h3>

                <form action="products" method="GET" id="filterForm">
                    <c:if test="${not empty keyword}">
                        <input type="hidden" name="keyword" value="${keyword}">
                    </c:if>

                    <div style="display: flex; flex-direction: column; gap: 2px;">
                        <label class="radio-label">
                            <input type="radio" name="category_id" value="" 
                                   onchange="document.getElementById('filterForm').submit();"
                                   ${empty activeCategory ? 'checked' : ''}> 
                            <b style="color: #d70018;">Tất cả sản phẩm</b>
                        </label>

                        <hr style="border: 0; border-top: 1px dashed #e5e7eb; margin: 10px 0;">

                        <c:forEach items="${categories}" var="c">
                            <c:if test="${c.parentId == 0}">
                                <label class="radio-label" style="font-weight: bold;">
                                    <input type="radio" name="category_id" value="${c.id}" 
                                           onchange="document.getElementById('filterForm').submit();"
                                           ${activeCategory == c.id ? 'checked' : ''}> 
                                    ${c.name}
                                </label>

                                <c:forEach items="${categories}" var="sub">
                                    <c:if test="${sub.parentId == c.id}">
                                        <label class="radio-label" style="margin-left: 20px; color: #666; font-size: 14px; padding-top: 4px; padding-bottom: 4px;">
                                            <input type="radio" name="category_id" value="${sub.id}" 
                                                   onchange="document.getElementById('filterForm').submit();"
                                                   ${activeCategory == sub.id ? 'checked' : ''}> 
                                            ↳ ${sub.name}
                                        </label>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                    </div>
                </form>
            </div>

            <div class="main-content">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background: white; padding: 15px; border-radius: 12px; box-shadow: 0 1px 5px rgba(0,0,0,0.05);">
                    <h2 class="title" style="margin: 0; font-size: 20px;">
                        <c:choose>
                            <c:when test="${not empty keyword}">Kết quả cho: "${keyword}"</c:when>
                            <c:otherwise>Sản phẩm nổi bật</c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="search-bar-header" style="margin: 0; max-width: 300px;">
                        <form action="products" method="GET" style="border: 1px solid #e5e7eb; padding: 2px;">
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên sản phẩm...">
                            <button type="submit">🔍</button>
                        </form>
                    </div>
                </div>

                <div class="product-grid">
                    <c:choose>
                        <c:when test="${empty data}">
                            <div style="grid-column: 1 / -1; text-align: center; padding: 60px; background: white; border-radius: 12px; box-shadow: 0 1px 5px rgba(0,0,0,0.05);">
                                <img src="https://cdn-icons-png.flaticon.com/512/2748/2748558.png" width="80" style="margin-bottom: 15px; opacity: 0.3;">
                                <h3 style="color: #666;">Không tìm thấy sản phẩm nào!</h3>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${data}" var="p">
                                <div class="product-card">
                                    <a href="detail?id=${p.id}">
                                        <img src="${not empty p.image ? p.image : 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'}" alt="${p.name}">
                                    </a>
                                    <h3 class="product-name">${p.name}</h3>
                                    <p class="price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</p>
                                    <form action="cart" method="POST" style="margin-top: auto;">
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
        </div>

        <%@include file="footer.jsp"%>
    </body>
</html>