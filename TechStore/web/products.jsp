<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sản phẩm - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body class="products-page-body">

        <%@include file="header.jsp"%>

        <div class="container products-container">

            <div class="sidebar-filter">
                <h3 class="sidebar-title">Bộ Lọc Sản Phẩm</h3>

                <form action="products" method="GET" id="filterForm">
                    
                    <h4 class="filter-title">Danh mục</h4>
                    <div class="category-filter-list">
                        <label class="radio-label">
                            <input type="radio" name="category_id" value="" 
                                   onchange="document.getElementById('filterForm').submit();"
                                   ${empty activeCategory ? 'checked' : ''}> 
                            <b class="${empty activeCategory ? 'text-red' : 'text-dark'}">Tất cả sản phẩm</b>
                        </label>

                        <c:forEach items="${categories}" var="c">
                            <c:if test="${c.parentId == 0}">
                                <label class="radio-label cat-level-1">
                                    <input type="radio" name="category_id" value="${c.id}" 
                                           onchange="document.getElementById('filterForm').submit();"
                                           ${activeCategory == c.id ? 'checked' : ''}> 
                                    <span class="${activeCategory == c.id ? 'text-red font-bold' : 'text-dark font-bold'}">${c.name}</span>
                                </label>

                                <c:forEach items="${categories}" var="sub">
                                    <c:if test="${sub.parentId == c.id}">
                                        <label class="radio-label cat-level-2">
                                            <input type="radio" name="category_id" value="${sub.id}" 
                                                   onchange="document.getElementById('filterForm').submit();"
                                                   ${activeCategory == sub.id ? 'checked' : ''}> 
                                            <span class="${activeCategory == sub.id ? 'text-red' : 'text-gray'}">↳ ${sub.name}</span>
                                        </label>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                    </div>

                    <h4 class="filter-title" style="margin-top: 25px;">Khoảng giá</h4>
                    <div class="price-input-group">
                        <input type="number" name="min_price" value="${minPrice}" placeholder="Từ đ">
                        <span class="price-sep">-</span>
                        <input type="number" name="max_price" value="${maxPrice}" placeholder="Đến đ">
                    </div>
                    
                    <button type="submit" class="filter-btn">Áp dụng bộ lọc</button>
                    <a href="products" class="clear-btn">Xóa bộ lọc</a>
                </form>
            </div>

            <div class="main-content">
                <div class="main-content-header">
                    <h2 class="title" style="margin: 0; padding-bottom: 0;">
                        <c:choose>
                            <c:when test="${not empty keyword}">Kết quả cho: <span class="text-red">"${keyword}"</span></c:when>
                            <c:otherwise>Danh sách sản phẩm</c:otherwise>
                        </c:choose>
                    </h2>
                    
                    <div class="sort-search-bar">
                        <select form="filterForm" name="sort_by" onchange="document.getElementById('filterForm').submit();" class="sort-select">
                            <option value="">Sắp xếp mặc định</option>
                            <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến cao</option>
                            <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Giá: Cao đến thấp</option>
                            <option value="best_selling" ${sortBy == 'best_selling' ? 'selected' : ''}>Bán chạy nhất</option>
                        </select>

                        <div class="search-bar-inner">
                            <input type="text" form="filterForm" name="keyword" value="${keyword}" placeholder="Tìm sản phẩm...">
                            <button type="submit" form="filterForm">🔍</button>
                        </div>
                    </div>
                </div>

                <div class="product-grid">
                    <c:choose>
                        <c:when test="${empty data}">
                            <div class="empty-products">
                                <img src="https://cdn-icons-png.flaticon.com/512/2748/2748558.png" alt="Empty">
                                <h3>Rất tiếc, không tìm thấy sản phẩm nào!</h3>
                                <p>Vui lòng thử điều chỉnh lại bộ lọc hoặc từ khóa tìm kiếm.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${data}" var="p">
                                <div class="product-card">
                                    <c:if test="${p.soldQuantity > 50}">
                                        <div class="badge-hot">🔥 BÁN CHẠY</div>
                                    </c:if>
                                    <a href="detail?id=${p.id}" class="product-img-link">
                                        <img src="${not empty p.image ? p.image : 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'}" alt="${p.name}">
                                    </a>
                                    <h3 class="product-name"><a href="detail?id=${p.id}">${p.name}</a></h3>
                                    <p class="price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</p>
                                    <p class="sold">Đã bán: ${p.soldQuantity}</p>
                                    
                                    <form action="cart" method="POST" class="add-cart-form">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button type="submit" class="btn-buy">Thêm vào giỏ</button>
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