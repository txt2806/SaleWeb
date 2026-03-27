<%@page import="dao.ProductDAO"%>
<%@page import="dao.CategoryDAO"%>
<%@page import="model.Product"%>
<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    model.User u = (model.User) session.getAttribute("user");
    if (u == null || u.getRole() != 1) {
        response.sendRedirect("login.jsp");
        return;
    }
    ProductDAO pDao = new ProductDAO();
    String sortBy = request.getParameter("sort_by");
    if (sortBy == null) sortBy = "";
    
    int pageNum = 1;
    String pageStr = request.getParameter("page");
    if (pageStr != null && !pageStr.isEmpty()) {
        try { pageNum = Integer.parseInt(pageStr); } catch (Exception e) {}
    }
    int pageSize = 10;
    
    int totalProducts = pDao.getTotalFilteredProducts(null, null, null, null);
    int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

    request.setAttribute("pList", pDao.getFilteredProducts(null, null, null, null, sortBy, pageNum, pageSize));
    request.setAttribute("sortBy", sortBy);
    request.setAttribute("currentPage", pageNum);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("cList", new CategoryDAO().getAllCategories());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quan tri he thong - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .admin-container {
                max-width: 1200px;
                margin: 20px auto;
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .section-title {
                color: #d70018;
                margin-bottom: 20px;
                border-left: 5px solid #d70018;
                padding-left: 10px;
                font-weight: bold;
            }
            .add-form-box {
                background: #f9fafb;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e5e7eb;
                margin-bottom: 30px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1.5fr auto;
                gap: 10px;
                align-items: end;
            }
            .form-grid input, .form-grid select {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                outline: none;
            }
            .admin-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .admin-table th {
                background: #f4f4f4;
                padding: 12px;
                text-align: left;
                border-bottom: 2px solid #d70018;
            }
            .admin-table td {
                padding: 12px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }
            .btn-apply {
                background: #16a34a;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
            }
            .action-link {
                padding: 5px 10px;
                border-radius: 4px;
                color: white;
                text-decoration: none;
                font-size: 12px;
                display: inline-block;
                margin-right: 5px;
            }
            .edit-link { background: #2563eb; }
            .delete-link { background: #dc2626; }
            .stock-low { color: #dc2626; font-weight: bold; }
            .stock-ok { color: #16a34a; font-weight: bold; }
        </style>
    </head>
    <body>
        <%@include file="header.jsp"%>

        <div class="container">
            <div class="admin-container">

                <h3 class="section-title">Thêm sản phẩm mới</h3>
                <div class="add-form-box">
                    <form action="admin/product" method="post" enctype="multipart/form-data" class="form-grid">
                        <input type="hidden" name="action" value="add">

                        <div style="display:flex; flex-direction:column; gap:5px;">
                            <label style="font-size:12px;">Tên sản phẩm:</label>
                            <input type="text" name="name" required>
                        </div>

                        <div style="display:flex; flex-direction:column; gap:5px;">
                            <label style="font-size:12px;">Giá (VND):</label>
                            <input type="number" name="price" required>
                        </div>

                        <div style="display:flex; flex-direction:column; gap:5px;">
                            <label style="font-size:12px;">Danh mục:</label>
                            <select name="category_id" required>
                                <c:forEach items="${cList}" var="c">
                                    <option value="${c.id}">${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div style="display:flex; flex-direction:column; gap:5px;">
                            <label style="font-size:12px;">Ảnh sản phẩm:</label>
                            <input type="file" name="imageFile" accept="image/*" required>
                        </div>

                        <button type="submit" class="btn" style="height: 40px; padding: 0 25px;">Thêm ngay</button>
                    </form>
                </div>

                <hr style="margin-bottom: 30px; border: 0; border-top: 1px solid #eee;">

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h3 class="section-title" style="margin:0;">Danh sách sản phẩm</h3>
                    <div style="display:flex; gap:8px;">
                        <button type="submit" form="stockForm" class="btn-apply" style="background:#2563eb;">📦 Cập nhật tồn kho</button>
                        <button type="submit" form="mainTableForm" class="btn-apply">⭐ Apply nổi bật</button>
                    </div>
                </div>

                <form id="stockForm" action="admin/product" method="POST" style="display:none;">
                    <input type="hidden" name="action" value="update_stock_batch">
                </form>

                <form id="mainTableForm" action="admin/product" method="POST">
                    <input type="hidden" name="action" value="update_featured_batch">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th width="50">ID</th>
                                <th width="80">Ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th><a href="?sort_by=${sortBy == 'price_desc' ? 'price_asc' : 'price_desc'}" style="color: inherit; text-decoration: none;">Giá bán ${sortBy == 'price_asc' ? '&uarr;' : (sortBy == 'price_desc' ? '&darr;' : '&updownarrow;')}</a></th>
                                <th><a href="?sort_by=${sortBy == 'best_selling' ? 'least_selling' : 'best_selling'}" style="color: inherit; text-decoration: none;">Đã bán ${sortBy == 'least_selling' ? '&uarr;' : (sortBy == 'best_selling' ? '&darr;' : '&updownarrow;')}</a></th>
                                <th>Tồn kho</th>
                                <th style="text-align: center;">Nổi bật</th>
                                <th style="text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pList}" var="p">
                                <tr>
                                    <td>${p.id}</td>
                                    <td><img src="${p.image}" width="45" height="45" style="object-fit: contain;"></td>
                                    <td><b>${p.name}</b></td>
                                    <td style="color:#d70018; font-weight:bold;">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/>đ
                                    </td>
                                    <td style="font-weight: 500;">
                                        ${p.soldQuantity}
                                    </td>
                                    <td>
                                        <input type="hidden" name="stockProductId" value="${p.id}" form="stockForm">
                                        <input type="number" name="stockValue" value="${p.stock}" min="0" form="stockForm"
                                               style="width:65px; padding:4px 6px; border:1px solid ${p.stock <= 3 ? '#dc2626' : '#ccc'}; border-radius:4px; font-weight:bold; color:${p.stock <= 3 ? '#dc2626' : '#16a34a'};">
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="checkbox" name="featuredIds" value="${p.id}" ${p.featured ? 'checked' : ''} style="transform: scale(1.3); cursor: pointer;">
                                    </td>
                                    <td style="text-align: center;">
                                        <a href="${pageContext.request.contextPath}/admin/product?action=prepare_edit&id=${p.id}" class="action-link edit-link">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin/product?action=delete&id=${p.id}" class="action-link delete-link" onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="text-align: center; margin-top: 20px;">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?sort_by=${sortBy}&page=${i}" 
                               style="display: inline-block; padding: 6px 12px; margin: 0 4px; border: 1px solid #ddd; text-decoration: none; color: ${i == currentPage ? '#fff' : '#333'}; background-color: ${i == currentPage ? '#d70018' : '#f9f9f9'}; border-radius: 4px;">
                                ${i}
                            </a>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <%@include file="footer.jsp"%>
    </body>
</html>