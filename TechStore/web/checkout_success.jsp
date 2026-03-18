<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt hàng thành công - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .success-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 60vh;
            }
            .success-box {
                background: white;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.05);
                text-align: center;
                max-width: 500px;
                width: 100%;
                border: 1px solid #f0f0f0;
            }
            .success-icon {
                width: 80px;
                height: 80px;
                background: #fef2f2;
                color: #d70018;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px auto;
            }
            .success-box h2 {
                color: #333;
                font-size: 24px;
                margin-bottom: 10px;
            }
            .success-box p {
                color: #666;
                font-size: 16px;
                line-height: 1.5;
                margin-bottom: 30px;
            }
            .btn-back-home {
                display: inline-block;
                background: #d70018;
                color: white;
                text-decoration: none;
                padding: 12px 30px;
                border-radius: 8px;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-back-home:hover {
                background: #bf0015;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(215, 0, 24, 0.3);
            }
        </style>
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="container success-wrapper">
            <div class="success-box">
                <div class="success-icon">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>
                <h2>Đặt hàng thành công!</h2>
                <p>Đơn hàng của bạn đã được tiếp nhận. <br> Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận giao hàng.</p>

                <a href="home" class="btn-back-home">Quay về trang chủ</a>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>