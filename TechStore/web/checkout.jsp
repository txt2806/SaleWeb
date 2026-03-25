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

                <form action="checkout" method="post" id="checkoutForm">
                    <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #333;">Địa chỉ nhận hàng (*)</label>
                    <input type="text" name="address" placeholder="Nhập số nhà, tên đường, phường/xã, quận/huyện..." required 
                           style="width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ccc; border-radius: 6px; outline: none;">

                    <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #333;">Số điện thoại nhận hàng (*)</label>
                    <input type="text" name="phone" id="checkoutPhone" value="${sessionScope.user.phone}" placeholder="Ví dụ: +84912345678" required 
                           style="width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 6px; outline: none;">

                    <div id="recaptcha-container"></div>
                    <div class="form-group" id="otp-group" style="display:none; margin-top:10px; background:#f9f9f9; padding:15px; border-radius:8px; border: 1px dashed #ccc; margin-bottom:20px;">
                        <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #333;">Xác minh Số điện thoại</label>
                        <input type="text" id="otp" placeholder="Nhập mã OTP từ tin nhắn SMS..." style="width: 100%; padding: 12px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 6px; outline: none;">
                        <button type="button" id="btnVerifyOTP" class="btn" style="background:#4ade80; width: 100%;">Xác nhận OTP</button>
                    </div>

                    <button type="button" id="btnSendOTP" class="btn" style="background:#f59e0b; width: 100%; margin-bottom:20px; display:none;">Gửi OTP xác minh</button>
                    <button type="submit" id="btnSubmitCheckout" class="btn" style="width: 100%; font-size: 16px; padding: 14px; border-radius: 8px;">Xác nhận đặt hàng</button>
                </form>
            </div>
        </div>

        <script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-auth.js"></script>
        <script>
            const firebaseConfig = {
                apiKey: "AIzaSyAhLKndXDDp_irCW3mIfdeFt3vnlFnYlBE",
                authDomain: "techstore-361e2.firebaseapp.com",
                projectId: "techstore-361e2",
                storageBucket: "techstore-361e2.firebasestorage.app",
                messagingSenderId: "858945999785",
                appId: "1:858945999785:web:07d4d8cbd248ceb311eab8"
            };
            if (firebase.apps.length === 0) {
                firebase.initializeApp(firebaseConfig);
            }

            const originalPhone = "${sessionScope.user.phone}";
            const isVerifiedOrig = "${sessionScope.user.isVerified}";

            function checkPhone() {
                const currentPhone = document.getElementById("checkoutPhone").value.trim();
                if (currentPhone === originalPhone && isVerifiedOrig === "1") {
                    document.getElementById("btnSendOTP").style.display = "none";
                    document.getElementById("btnSubmitCheckout").disabled = false;
                    document.getElementById("btnSubmitCheckout").style.opacity = "1";
                    document.getElementById("btnSubmitCheckout").innerText = "Xác nhận đặt hàng";
                } else if (currentPhone !== "") {
                    document.getElementById("btnSendOTP").style.display = "block";
                    document.getElementById("btnSubmitCheckout").disabled = true;
                    document.getElementById("btnSubmitCheckout").style.opacity = "0.5";
                    document.getElementById("btnSubmitCheckout").innerText = "Vui lòng xác minh SĐT để tiếp tục";
                }
            }

            document.getElementById("checkoutPhone").addEventListener("input", function() {
                document.getElementById("otp-group").style.display = "none";
                checkPhone();
            });
            checkPhone();

            document.addEventListener("DOMContentLoaded", function () {
                if(typeof firebase !== "undefined" && firebase.apps.length > 0) {
                    window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier("recaptcha-container", { "size": "invisible" });
                }
            });

            document.getElementById("btnSendOTP").onclick = function() {
                const phone = document.getElementById("checkoutPhone").value.trim();
                if(!phone.startsWith("+84") && phone.startsWith("0")) {
                    alert("Vui lòng nhập số điện thoại bắt đầu bằng +84 (VD: +84912345678)");
                    return;
                }
                this.innerText = "Đang gửi SMS...";
                firebase.auth().signInWithPhoneNumber(phone, window.recaptchaVerifier)
                    .then(function (confirmationResult) {
                        window.confirmationResult = confirmationResult;
                        document.getElementById("otp-group").style.display = "block";
                        document.getElementById("btnSendOTP").style.display = "none";
                        alert("Mã OTP đã được gửi tới SĐT của bạn!");
                    }).catch(function (error) {
                        alert("Lỗi khi gửi SMS: " + error.message);
                        document.getElementById("btnSendOTP").innerText = "Gửi OTP xác minh";
                    });
            };

            document.getElementById("btnVerifyOTP").onclick = function() {
                const code = document.getElementById("otp").value;
                if(!code) return alert("Vui lòng nhập mã OTP");
                confirmationResult.confirm(code).then(function (result) {
                    alert("Xác thực thành công!");
                    document.getElementById("otp-group").style.display = "none";
                    document.getElementById("btnSubmitCheckout").disabled = false;
                    document.getElementById("btnSubmitCheckout").style.opacity = "1";
                    document.getElementById("btnSubmitCheckout").innerText = "Xác nhận đặt hàng";
                }).catch(function (error) {
                    alert("Mã OTP không đúng!");
                });
            };
        </script>

        <%@include file="footer.jsp"%>

    </body>
</html>