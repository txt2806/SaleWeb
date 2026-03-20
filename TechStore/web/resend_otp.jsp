<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gửi Lại Mã Xác Nhận - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body style="background-color: #f8f9fa;">

        <%@include file="header.jsp"%>

        <div class="auth-wrapper">
            <div class="auth-box" style="text-align: center;">
                <h2 class="auth-title">Gửi Lại Mã OTP</h2>
                <p class="auth-subtitle">Vui lòng nhập Email bạn đã đăng ký</p>

                <c:if test="${not empty error}">
                    <div class="error-msg">⚠️ ${error}</div>
                </c:if>

                <form action="resend-otp" method="POST" class="auth-form" style="text-align: left;">
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Địa chỉ Email" required>
                    </div>
                    <button type="submit" class="auth-btn">Gửi Mã Mới</button>
                </form>
                
                <div class="auth-links">
                    <a href="login.jsp">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>
