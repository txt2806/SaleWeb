<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-wrapper">
            <div class="auth-box">
                <div class="auth-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/3596/3596091.png" width="60" alt="Register Icon" style="opacity: 0.8;">
                </div>
                <h2 class="auth-title">Đăng Ký</h2>
                <p class="auth-subtitle">Tạo tài khoản để nhận nhiều ưu đãi</p>

                <form action="register" method="post" class="auth-form">
                    <div class="form-group">
                        <input type="text" name="username" placeholder="Tên đăng nhập" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" placeholder="Mật khẩu" required>
                    </div>
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Địa chỉ Email" required>
                    </div>
                    <div class="form-group">
                        <input type="text" name="phone" placeholder="Số điện thoại" required>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            ⚠️ ${error}
                        </div>
                    </c:if>

                    <button class="auth-btn">ĐĂNG KÝ TÀI KHOẢN</button>
                </form>

                <div class="auth-links">
                    Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>