<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi Mật Khẩu - TechStore</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .auth-container {
            max-width: 400px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .auth-container h2 {
            text-align: center;
            color: #d70018;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #d70018;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #b90015;
        }
        .msg-error {
            color: #dc2626;
            margin-bottom: 15px;
            font-weight: bold;
            text-align: center;
        }
        .msg-success {
            color: #16a34a;
            margin-bottom: 15px;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body style="background:#f4f4f4">

    <jsp:include page="header.jsp" />

    <div class="auth-container">
        <h2>🔑 Đổi Mật Khẩu</h2>
        
        <c:if test="${not empty error}">
            <div class="msg-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="msg-success">${success}</div>
        </c:if>

        <form action="change_password" method="POST">
            <div class="form-group">
                <label>Mật khẩu cũ:</label>
                <input type="password" name="old_password" required>
            </div>
            
            <div class="form-group">
                <label>Mật khẩu mới:</label>
                <input type="password" name="new_password" required minlength="6">
            </div>
            
            <div class="form-group">
                <label>Xác nhận mật khẩu mới:</label>
                <input type="password" name="confirm_password" required minlength="6">
            </div>

            <button type="submit" class="btn-submit">Cập nhật mật khẩu</button>
        </form>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
