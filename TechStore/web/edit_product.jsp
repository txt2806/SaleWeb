<%@page import="dao.ProductDAO"%>
<%@page import="model.Product"%>
<%@page import="dao.CategoryDAO"%>
<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // Kiem tra quyen dang nhap
    model.User u = (model.User) session.getAttribute("user");
    if (u == null || u.getRole() != 1) {
        response.sendRedirect("login.jsp");
        return;
    }
    request.setAttribute("cList", new CategoryDAO().getAllCategories());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa sản phẩm - TechStore Admin</title>
    <!-- Use Google Fonts for Modern Typography -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        .edit-container {
            max-width: 650px;
            margin: 60px auto 100px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08), 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.5);
            animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .page-header {
            text-align: center;
            margin-bottom: 35px;
        }
        .page-header h2 {
            color: #111827;
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 10px 0;
        }
        .page-header p {
            color: #6b7280;
            margin: 0;
            font-size: 15px;
        }
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            padding: 14px 16px;
            font-size: 15px;
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            transition: all 0.3s ease;
            box-sizing: border-box;
            color: #111827;
        }
        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        .image-preview-container {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #f9fafb;
            padding: 20px;
            border-radius: 12px;
            border: 2px dashed #d1d5db;
        }
        .image-preview {
            width: 100px;
            height: 100px;
            border-radius: 10px;
            object-fit: cover;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            background: #ffffff;
        }
        .file-input-wrapper {
            flex: 1;
        }
        .file-input-wrapper input[type=file]::file-selector-button {
            border: none;
            background: #eff6ff;
            color: #2563eb;
            padding: 10px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin-right: 15px;
        }
        .file-input-wrapper input[type=file]::file-selector-button:hover {
            background: #dbeafe;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 40px;
        }
        .btn-modern {
            flex: 1;
            padding: 16px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
        }
        .btn-save {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
        }
        .btn-cancel {
            background: #ffffff;
            color: #4b5563;
            border: 2px solid #e5e7eb;
        }
        .btn-cancel:hover {
            background: #f3f4f6;
            color: #1f2937;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp"%>
    
    <c:set var="p" value="${productToEdit}"/>

    <div class="edit-container">
        <div class="page-header">
            <h2>Chỉnh sửa sản phẩm</h2>
            <p>Cập nhật thông tin chi tiết cho <b>${p.name}</b></p>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/product" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" value="${p.id}">

            <div class="form-group">
                <label class="form-label">Tên sản phẩm ✨</label>
                <input type="text" name="name" class="form-control" value="${p.name}" placeholder="Nhập tên sản phẩm..." required>
            </div>

            <div class="form-group">
                <label class="form-label">Giá bán (VNĐ) 💰</label>
                <input type="number" name="price" class="form-control" value="${p.price}" placeholder="Ví dụ: 25000000" required>
            </div>

            <div class="form-group">
                <label class="form-label">Danh mục sản phẩm 📁</label>
                <select name="category_id" class="form-control" required>
                    <c:forEach items="${cList}" var="c">
                        <option value="${c.id}" ${p.categoryId == c.id ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Hình ảnh sản phẩm 📸</label>
                <div class="image-preview-container">
                    <img id="previewImg" class="image-preview" src="${pageContext.request.contextPath}/${p.image}" onerror="this.src='https://cdn-icons-png.flaticon.com/512/1041/1041372.png'" alt="Preview">
                    <div class="file-input-wrapper">
                        <input type="file" id="imageInput" name="imageFile" accept="image/*" class="form-control" style="background: transparent; border: none; padding: 0; box-shadow: none;">
                        <p style="font-size: 12px; color: #9ca3af; margin-top: 5px;">Hỗ trợ: JPG, PNG, WEBP (Tối đa 5MB)</p>
                    </div>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/admin_dashboard.jsp" class="btn-modern btn-cancel">Hủy bỏ</a>
                <button type="submit" class="btn-modern btn-save">Lưu thay đổi 🚀</button>
            </div>
        </form>
    </div>

    <%@include file="footer.jsp"%>

    <script>
        document.getElementById('imageInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('previewImg');
                    preview.style.opacity = '0';
                    setTimeout(() => {
                        preview.src = e.target.result;
                        preview.style.transition = 'opacity 0.3s ease';
                        preview.style.opacity = '1';
                    }, 200);
                }
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>