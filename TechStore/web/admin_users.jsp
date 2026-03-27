<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
        <title>Quản lý Người dùng - TechStore</title>
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
                padding: 6px 12px;
                border-radius: 4px;
                color: white;
                text-decoration: none;
                font-size: 13px;
                font-weight: bold;
                display: inline-block;
            }
            .reset-link {
                background: #f59e0b; /* yellow for warning */
            }
            .admin-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                background: #fef08a;
                color: #854d0e;
            }
            .user-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                background: #e0f2fe;
                color: #075985;
            }
            .verified { color: #16a34a; font-weight: bold; }
            .unverified { color: #dc2626; font-weight: bold; }
        </style>
    </head>
    <body style="background:#f4f4f4">
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="admin-container">
                <h3 class="section-title">👥 Quản lý Người dùng</h3>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th width="50">ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Email</th>
                            <th>Vai trò</th>
                            <th>Xác minh</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty users}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding: 20px;">Không có dữ liệu.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${users}" var="usr">
                                    <tr>
                                        <td>${usr.id}</td>
                                        <td><b>${usr.username}</b></td>
                                        <td>${not empty usr.email ? usr.email : '<i>Trống</i>'}</td>
                                        <td>
                                            <span class="${usr.role == 1 ? 'admin-badge' : 'user-badge'}">
                                                ${usr.role == 1 ? 'Admin' : 'Khách hàng'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="${usr.isVerified == 1 ? 'verified' : 'unverified'}">
                                                ${usr.isVerified == 1 ? '✅ Đã xác minh' : '❌ Chưa xác minh'}
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <c:if test="${usr.role == 0}">
                                                <a href="<%= request.getContextPath() %>/admin/reset_password?id=${usr.id}" 
                                                   class="action-link reset-link" 
                                                   onclick="return confirm('Bạn có chắc muốn Reset mật khẩu của user này về 123456?');">
                                                   🔑 Reset MK
                                                </a>
                                                <form action="<%= request.getContextPath() %>/admin/users" method="post" style="display:inline; margin-left:5px;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${usr.id}">
                                                    <button type="submit" class="action-link" style="background:#dc2626; border:none; cursor:pointer;" 
                                                            onclick="return confirm('Bạn có chắc muốn XÓA user ${usr.username}? Hành động này không thể hoàn tác!');">
                                                        🗑 Xóa
                                                    </button>
                                                </form>
                                            </c:if>
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
