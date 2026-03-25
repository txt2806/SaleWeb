<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    model.User u = (model.User) session.getAttribute("user");
    if (u == null || u.getRole() != 1) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Đơn hàng #${orderId} - TechStore</title>
        <link rel="stylesheet" href="../css/style.css">
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
            .btn-back {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background: #6b7280;
                color: white;
                text-decoration: none;
                border-radius: 5px;
            }
        </style>
    </head>
    <body style="background:#f4f4f4">
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="admin-container">
                <h3 class="section-title">🔍 Chi tiết Đơn hàng #${orderId}</h3>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th width="80">Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${details}" var="d">
                            <tr>
                                <td>
                                    <img src="<%= request.getContextPath() %>/${not empty d.productImage ? d.productImage : 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'}" width="50" height="50" style="object-fit:cover">
                                </td>
                                <td><b>${d.productName}</b> <br> <small style="color:gray;">Mã SP: ${d.productId}</small></td>
                                <td style="color:#d70018; font-weight:bold;"><fmt:formatNumber value="${d.price}" pattern="#,###"/>đ</td>
                                <td>${d.quantity}</td>
                                <td style="color:#d70018; font-weight:bold;"><fmt:formatNumber value="${d.price * d.quantity}" pattern="#,###"/>đ</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <a href="<%= request.getContextPath() %>/admin/orders" class="btn-back">⬅ Quay lại danh sách</a>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
