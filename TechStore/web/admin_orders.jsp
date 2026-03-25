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
        <title>Quan ly don hang - TechStore</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
            .view-link { background: #2563eb; }
            .status-pending { background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
            .status-delivering { background: #dbeafe; color: #1e40af; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
            .status-completed { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
            .status-cancelled { background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
            .status-form select {
                padding: 6px 10px;
                border: 1px solid #d1d5db;
                border-radius: 4px;
                font-size: 13px;
                cursor: pointer;
            }
            .status-form button {
                padding: 6px 12px;
                border: none;
                background: #2563eb;
                color: white;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                font-weight: bold;
            }
            .status-form button:hover { background: #1d4ed8; }
        </style>
    </head>
    <body style="background:#f4f4f4">
        
        <%@include file="header.jsp"%>

        <div class="container">
            <div class="admin-container">
                <h3 class="section-title">Quan ly Don hang da ban</h3>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th width="80">Ma DH</th>
                            <th>Ma User (Khach)</th>
                            <th>Ngay mua</th>
                            <th>Tong tien</th>
                            <th>Trang thai</th>
                            <th>Cap nhat trang thai</th>
                            <th style="text-align: center;">Thao tac</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr>
                                    <td colspan="7" style="text-align:center; padding: 20px;">Chua co don hang nao.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${orders}" var="o">
                                    <tr>
                                        <td>#${o.id}</td>
                                        <td>${o.userId}</td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td style="color:#d70018; font-weight:bold;">
                                            <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>d
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.status == 'Pending'}">
                                                    <span class="status-pending">Cho xu ly</span>
                                                </c:when>
                                                <c:when test="${o.status == 'Delivering'}">
                                                    <span class="status-delivering">Dang giao</span>
                                                </c:when>
                                                <c:when test="${o.status == 'Completed'}">
                                                    <span class="status-completed">Hoan thanh</span>
                                                </c:when>
                                                <c:when test="${o.status == 'Cancelled'}">
                                                    <span class="status-cancelled">Da huy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span>${o.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form class="status-form" action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:flex; gap:5px; align-items:center;">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="order_id" value="${o.id}">
                                                <select name="new_status">
                                                    <option value="Pending" ${o.status == 'Pending' ? 'selected' : ''}>Cho xu ly</option>
                                                    <option value="Delivering" ${o.status == 'Delivering' ? 'selected' : ''}>Dang giao</option>
                                                    <option value="Completed" ${o.status == 'Completed' ? 'selected' : ''}>Hoan thanh</option>
                                                    <option value="Cancelled" ${o.status == 'Cancelled' ? 'selected' : ''}>Da huy</option>
                                                </select>
                                                <button type="submit">Luu</button>
                                            </form>
                                        </td>
                                        <td style="text-align: center;">
                                            <a href="${pageContext.request.contextPath}/admin/orders?action=view_detail&id=${o.id}" class="action-link view-link">Xem chi tiet</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%@include file="footer.jsp"%>
    </body>
</html>
