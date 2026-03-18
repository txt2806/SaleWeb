<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thanh toán - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="container" style="max-width: 600px;">
            <div class="form-box" style="margin: 30px auto; width: 100%; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h2 style="color: #d70018; margin-bottom: 20px; text-align: center; font-weight: 800;">Thông tin đơn hàng</h2>

                <c:set var="total" value="0"/>

                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 25px;">
                    <c:forEach items="${sessionScope.cart}" var="c">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px dashed #ccc; padding-bottom: 15px;">
                            <span style="color: #444; font-size: 15px;">${c.product.name} <b style="color: #d70018;">(x${c.quantity})</b></span>
                            <span style="color: #d70018; font-weight: bold; font-size: 15px;">
                                <fmt:formatNumber value="${c.total}" pattern="#,###"/>đ
                            </span>
                        </div>
                        <c:set var="total" value="${total + c.total}"/>
                    </c:forEach>

                    <h3 style="text-align: right; margin-top: 20px; color: #333; font-size: 18px;">
                        Tổng thanh toán: <span style="color: #d70018; font-size: 24px; font-weight: bold;"><fmt:formatNumber value="${total}" pattern="#,###"/>đ</span>
                    </h3>
                </div>

                <form action="checkout" method="post">
                    <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #333;">Địa chỉ nhận hàng (*)</label>
                    <input type="text" name="address" placeholder="Nhập số nhà, tên đường, phường/xã, quận/huyện..." required 
                           style="width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ccc; border-radius: 6px; outline: none;">

                    <button type="submit" class="btn" style="width: 100%; font-size: 16px; padding: 14px; border-radius: 8px;">Xác nhận đặt hàng</button>
                </form>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>