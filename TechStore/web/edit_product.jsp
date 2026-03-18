<%@page import="dao.ProductDAO"%>
<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa sản phẩm - TechStore</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@include file="header.jsp"%>
    <div class="container" style="max-width: 600px; margin-top: 50px;">
        <div class="form-box" style="background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
            <h2 style="color: #d70018; margin-bottom: 20px;">Chỉnh sửa sản phẩm</h2>
            
            <%-- Lấy dữ liệu sản phẩm từ request do Servlet gửi sang --%>
            <c:set var="p" value="${productToEdit}"/>
            
            <form action="admin/product" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="${p.id}">

                <label>Tên sản phẩm:</label>
                <input type="text" name="name" value="${p.name}" required style="width:100%; padding:10px; margin: 10px 0;">

                <label>Giá bán (VNĐ):</label>
                <input type="number" name="price" value="${p.price}" required style="width:100%; padding:10px; margin: 10px 0;">

                <label>Ảnh hiện tại:</label><br>
                <img src="${p.image}" width="100" style="margin: 10px 0;"><br>
                <label>Thay ảnh mới (nếu muốn):</label>
                <input type="file" name="imageFile" style="width:100%; margin: 10px 0;">

                <div style="margin-top: 20px; display: flex; gap: 10px;">
                    <button type="submit" class="btn" style="flex: 1;">Lưu thay đổi</button>
                    <a href="admin_dashboard.jsp" class="btn" style="flex: 1; background: #666; text-decoration: none;">Hủy</a>
                </div>
            </form>
        </div>
    </div>
    <%@include file="footer.jsp"%>
</body>
</html>