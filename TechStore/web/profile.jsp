<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông tin cá nhân - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-wrapper" style="margin-top: 50px;">
            <div class="auth-box" style="width: 500px; max-width: 90%;">
                <h2 class="auth-title">Hồ Sơ Cá Nhân</h2>
                
                <c:if test="${param.success == '1'}">
                    <div style="background: #d4edda; color: #155724; padding: 10px; text-align: center; border-radius: 5px; margin-bottom: 15px;">
                        Cập nhật thông tin thành công!
                    </div>
                </c:if>

                <form action="profile" method="post" class="auth-form" id="profileForm">
                    <input type="hidden" name="isEmailVerified" id="isEmailVerified" value="1">
                    <input type="hidden" name="isPhoneVerified" id="isPhoneVerified" value="1">

                    <div style="text-align: center; margin-bottom: 20px;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatar}">
                                <img id="previewAvatar" src="${sessionScope.user.avatar}" 
                                     onerror="this.onerror=null;this.src='https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random';" 
                                     style="width:100px; height:100px; border-radius:50%; object-fit:cover; border:2px solid #ccc;">
                            </c:when>
                            <c:otherwise>
                                <img id="previewAvatar" src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random" 
                                     style="width:100px; height:100px; border-radius:50%; object-fit:cover; border:2px solid #ccc;">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="form-group">
                        <label>Ảnh đại diện (Image URL):</label>
                        <input type="text" name="avatar" id="avatarUrl" value="${sessionScope.user.avatar}" placeholder="Nhập link ảnh (VD: https://...)">
                    </div>

                    <div class="form-group">
                        <label>Tên đăng nhập / Họ tên:</label>
                        <input type="text" name="username" value="${sessionScope.user.username}" required>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ Email (Đổi email sẽ cần xác minh lại):</label>
                        <input type="email" name="email" id="profileEmail" value="${sessionScope.user.email}" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="text" name="phone" id="profilePhone" value="${sessionScope.user.phone}" placeholder="+84...">
                    </div>

                    <div id="recaptcha-container"></div>
                    <div class="form-group" id="otp-group" style="display:none; margin-top:10px; background:#f9f9f9; padding:10px; border-radius:5px;">
                        <input type="text" id="otp" placeholder="Nhập mã OTP từ SMS">
                        <button type="button" id="btnVerifyOTP" class="auth-btn" style="background:#4ade80; margin-top:5px;">XÁC NHẬN SĐT MỚI</button>
                    </div>

                    <button type="button" id="btnSendOTP" class="auth-btn" style="background:#f59e0b; margin-top:10px; display:none;">GỬI OTP ĐỂ XÁC MINH SĐT MỚI</button>

                    <button type="submit" id="btnSubmitProfile" class="auth-btn" style="margin-top:20px;">LƯU THAY ĐỔI</button>
                </form>
            </div>
        </div>

        <%@include file="footer.jsp"%>

        <script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-auth.js"></script>
        <script>
            const firebaseConfig = {
                apiKey: "AIzaSyAhLKndXDDp_irCW3mIfdeFt3vnlFnYlBE",
                authDomain: "techstore-361e2.firebaseapp.com",
                projectId: "techstore-361e2",
                storageBucket: "techstore-361e2.firebasestorage.app",
                messagingSenderId: "858945999785",
                appId: "1:858945999785:web:07d4d8cbd248ceb311eab8",
                measurementId: "G-D04FD2NPH9"
            };
            if (firebase.apps.length === 0) {
                firebase.initializeApp(firebaseConfig);
            }

            // Real-time avatar update
            document.getElementById('avatarUrl').addEventListener('input', function() {
                if(this.value.trim() !== '') {
                    document.getElementById('previewAvatar').src = this.value;
                }
            });

            // Logic required to re-verify phone / email
            const originalEmail = document.getElementById("profileEmail").defaultValue;
            const originalPhone = document.getElementById("profilePhone").defaultValue;

            document.getElementById("profileEmail").addEventListener('input', function() {
                if(this.value !== originalEmail) {
                    document.getElementById("isEmailVerified").value = "0";
                } else {
                    document.getElementById("isEmailVerified").value = "1";
                }
            });

            document.getElementById("profilePhone").addEventListener('input', function() {
                if(this.value !== originalPhone && this.value.trim() !== "") {
                    document.getElementById("isPhoneVerified").value = "0";
                    document.getElementById("btnSendOTP").style.display = "block";
                    document.getElementById("btnSubmitProfile").disabled = true;
                    document.getElementById("btnSubmitProfile").style.opacity = "0.5";
                    document.getElementById("btnSubmitProfile").innerText = "VUI LÒNG XÁC MINH SDT ĐỂ LƯU";
                } else {
                    document.getElementById("isPhoneVerified").value = "1";
                    document.getElementById("btnSendOTP").style.display = "none";
                    document.getElementById("otp-group").style.display = "none";
                    document.getElementById("btnSubmitProfile").disabled = false;
                    document.getElementById("btnSubmitProfile").style.opacity = "1";
                    document.getElementById("btnSubmitProfile").innerText = "LƯU THAY ĐỔI";
                }
            });

            document.addEventListener("DOMContentLoaded", function () {
                if(typeof firebase !== "undefined" && firebase.apps.length > 0) {
                    window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier("recaptcha-container", { "size": "invisible" });
                }
            });

            document.getElementById("btnSendOTP").onclick = function() {
                const phone = document.getElementById("profilePhone").value;
                if(!phone.startsWith("+84") && phone.startsWith("0")) {
                    alert("Vui lòng nhập số điện thoại định dạng +84 (VD: +84912345678)");
                    return;
                }
                this.innerText = "Đang gửi SMS...";
                firebase.auth().signInWithPhoneNumber(phone, window.recaptchaVerifier)
                    .then(function (confirmationResult) {
                        window.confirmationResult = confirmationResult;
                        document.getElementById("otp-group").style.display = "block";
                        document.getElementById("btnSendOTP").style.display = "none";
                        alert("Đã gửi mã OTP!");
                    }).catch(function (error) {
                        alert("Lỗi khi gửi SMS: " + error.message);
                        document.getElementById("btnSendOTP").innerText = "GỬI OTP ĐỂ XÁC MINH SĐT MỚI";
                    });
            };

            document.getElementById("btnVerifyOTP").onclick = function() {
                const code = document.getElementById("otp").value;
                confirmationResult.confirm(code).then(function (result) {
                    alert("Xác thực SĐT mới thành công!");
                    document.getElementById("isPhoneVerified").value = "1";
                    document.getElementById("otp-group").style.display = "none";
                    
                    document.getElementById("btnSubmitProfile").disabled = false;
                    document.getElementById("btnSubmitProfile").style.opacity = "1";
                    document.getElementById("btnSubmitProfile").innerText = "LƯU THAY ĐỔI";
                }).catch(function (error) {
                    alert("Mã OTP không đúng!");
                });
            };
        </script>
    </body>
</html>
