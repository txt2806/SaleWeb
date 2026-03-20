<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xác thực Email - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-container">
            <h2>Nhập mã xác nhận</h2>
            <p style="color: #666; font-size: 15px; line-height: 1.5;">Mã OTP 6 số đã được gửi tới địa chỉ Email:<br><b style="color: #333;">${sessionScope.emailVerify}</b></p>

            <p style="color: red; font-size: 14px; margin-top: 10px; font-weight: bold;">${error}</p>

            <form action="verify" method="POST">
                <input type="text" name="otp" placeholder="------" maxlength="6" required autocomplete="off">
                <button type="submit" class="btn" style="width: 100%; padding: 14px; font-size: 16px; border-radius: 8px;">Kích hoạt tài khoản</button>
            </form>
            
            <div style="margin-top: 15px;">
                <a href="resend_otp.jsp" style="color: #007bff; text-decoration: none; font-size: 14px;">Chưa nhận được mã? Gửi lại mã.</a>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>