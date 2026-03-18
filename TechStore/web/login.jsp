<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-wrapper">
            <div class="auth-box">
                <div class="auth-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/295/295128.png" width="60" alt="Login Icon" style="opacity: 0.8;">
                </div>
                <h2 class="auth-title">Đăng Nhập</h2>
                <p class="auth-subtitle">Chào mừng bạn trở lại với TechStore</p>

                <form action="login" method="post" class="auth-form">
                    <div class="form-group">
                        <input type="text" name="username" placeholder="Tên đăng nhập" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" placeholder="Mật khẩu" required>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            ⚠️ ${error}
                        </div>
                    </c:if>

                    <button class="auth-btn">ĐĂNG NHẬP</button>
                </form>

                <div class="auth-links">
                    Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>