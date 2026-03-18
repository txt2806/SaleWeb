<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${product.name} - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="container">
            <div style="background: white; border-radius: 16px; padding: 40px; display: flex; gap: 40px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-top: 20px;">
                <div style="flex: 1; text-align: center; padding: 20px; border: 1px solid #f0f0f0; border-radius: 12px;">
                    <img src="${product.image}" alt="${product.name}" style="max-width: 100%; height: 400px; object-fit: contain;">
                </div>

                <div style="flex: 1;">
                    <h1 style="font-size: 28px; font-weight: 800; color: #333; margin-bottom: 10px;">${product.name}</h1>
                    <p style="color: #666; font-size: 14px; margin-bottom: 20px;">Mã SP: #${product.id} | Danh mục: ${product.categoryId}</p>

                    <p style="font-size: 32px; font-weight: bold; color: #d70018; margin-bottom: 30px;">
                    <fmt:formatNumber value="${product.price}" pattern="#,###"/>đ
                    </p>

                    <div style="background: #f8f9fa; padding: 20px; border-radius: 12px; margin-bottom: 30px; line-height: 1.6;">
                        <h3 style="margin-bottom: 10px; color: #d70018; font-size: 16px;">Đặc điểm nổi bật:</h3>
                        <p style="color: #444;">${product.description}</p>
                    </div>

                    <form action="cart" method="post" style="display: flex; gap: 15px;">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="${product.id}">
                        <button type="submit" class="btn" style="flex: 1; padding: 18px; font-size: 18px; border-radius: 12px;">🛒 THÊM VÀO GIỎ HÀNG</button>
                    </form>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp"%>
    </body>
</html>