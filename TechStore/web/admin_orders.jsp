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
        <title>Quản lý đơn hàng - TechStore</title>
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
            .action-link {
                padding: 5px 10px;
                border-radius: 4px;
                color: white;
                text-decoration: none;
                font-size: 12px;
                display: inline-block;
                margin-right: 5px;
            }
            .view-link {
                background: #2563eb;
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                background: #dcfce7;
                color: #166534;
            }
        </style>
    </head>
    <body style="background:#f4f4f4">
        <!-- Cannot include header.jsp easily without fixing paths if in /admin/ context, wait, the Servlet maps to /admin/orders but forwards to /admin_orders.jsp, so it's in root. -->
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="admin-container">
                <h3 class="section-title">📦 Quản lý Đơn hàng đã bán</h3>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th width="80">Mã ĐH</th>
                            <th>Mã User (Khách)</th>
                            <th>Ngày mua</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding: 20px;">Chưa có đơn hàng nào.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${orders}" var="o">
                                    <tr>
                                        <td>#${o.id}</td>
                                        <td>${o.userId}</td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td style="color:#d70018; font-weight:bold;">
                                            <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>đ
                                        </td>
                                        <td><span class="status-badge">${o.status}</span></td>
                                        <td style="text-align: center;">
                                            <a href="<%= request.getContextPath() %>/admin/orders?action=view_detail&id=${o.id}" class="action-link view-link">Xem chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
