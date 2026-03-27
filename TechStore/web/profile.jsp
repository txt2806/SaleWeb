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
                <c:if test="${param.error == 'email_exists'}">
                    <div style="background: #f8d7da; color: #721c24; padding: 10px; text-align: center; border-radius: 5px; margin-bottom: 15px;">
                        Email đã được sử dụng bởi tài khoản khác!
                    </div>
                </c:if>
                <c:if test="${param.error == 'phone_exists'}">
                    <div style="background: #f8d7da; color: #721c24; padding: 10px; text-align: center; border-radius: 5px; margin-bottom: 15px;">
                        Số điện thoại đã được sử dụng bởi tài khoản khác!
                    </div>
                </c:if>

                <form action="profile" method="post" class="auth-form" id="profileForm" enctype="multipart/form-data">
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
                        <label>Ảnh đại diện:</label>
                        <input type="file" name="avatarFile" id="avatarFile" accept="image/*" style="padding:8px;">
                        <p style="font-size:12px; color:#888; margin-top:4px;">Chọn ảnh từ máy tính (JPG, PNG, ...)</p>
                    </div>

                    <div class="form-group">
                        <label>Tên đăng nhập / Họ tên:</label>
                        <input type="text" name="username" value="${sessionScope.user.username}" required>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ Email:</label>
                        <input type="email" name="email" id="profileEmail" value="${sessionScope.user.email}" required>
                    </div>

                    <div class="form-group" id="email-verify-group" style="display:none; background:#fff3cd; padding:12px; border-radius:8px; border:1px dashed #ffc107;">
                        <p style="font-size:13px; color:#856404; margin-bottom:8px;">⚠️ Bạn đang đổi email. Nhập mật khẩu hiện tại để xác nhận.</p>
                        <input type="password" id="confirmPassword" placeholder="Nhập mật khẩu hiện tại" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:6px; margin-bottom:8px;">
                        <button type="button" id="btnConfirmEmail" class="auth-btn" style="background:#f59e0b;">XÁC NHẬN ĐỔI EMAIL</button>
                        <p id="emailVerifyStatus" style="font-size:13px; color:#155724; display:none; margin-top:8px;">✅ Đã xác nhận! Email mới sẽ được lưu.</p>
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

            // Live preview avatar khi chọn file
            document.getElementById('avatarFile').addEventListener('change', function(e) {
                if(this.files && this.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(ev) {
                        document.getElementById('previewAvatar').src = ev.target.result;
                    };
                    reader.readAsDataURL(this.files[0]);
                }
            });

            // Logic required to re-verify phone / email
            const originalEmail = document.getElementById("profileEmail").defaultValue;
            const originalPhone = document.getElementById("profilePhone").defaultValue;
            let emailVerified = true;
            let phoneVerified = true;

            function updateSubmitButton() {
                if (!emailVerified || !phoneVerified) {
                    document.getElementById("btnSubmitProfile").disabled = true;
                    document.getElementById("btnSubmitProfile").style.opacity = "0.5";
                    var msg = [];
                    if (!emailVerified) msg.push("Email");
                    if (!phoneVerified) msg.push("SĐT");
                    document.getElementById("btnSubmitProfile").innerText = "VUI LÒNG XÁC MINH " + msg.join(" & ") + " ĐỂ LƯU";
                } else {
                    document.getElementById("btnSubmitProfile").disabled = false;
                    document.getElementById("btnSubmitProfile").style.opacity = "1";
                    document.getElementById("btnSubmitProfile").innerText = "LƯU THAY ĐỔI";
                }
            }

            document.getElementById("profileEmail").addEventListener('input', function() {
                if(this.value !== originalEmail && this.value.trim() !== "") {
                    document.getElementById("isEmailVerified").value = "0";
                    document.getElementById("email-verify-group").style.display = "block";
                    document.getElementById("emailVerifyStatus").style.display = "none";
                    document.getElementById("btnConfirmEmail").style.display = "block";
                    document.getElementById("confirmPassword").value = "";
                    emailVerified = false;
                } else {
                    document.getElementById("isEmailVerified").value = "1";
                    document.getElementById("email-verify-group").style.display = "none";
                    emailVerified = true;
                }
                updateSubmitButton();
            });

            // Xác nhận đổi email bằng mật khẩu
            document.getElementById("btnConfirmEmail").onclick = function() {
                var pwd = document.getElementById("confirmPassword").value;
                if (!pwd) { alert("Vui lòng nhập mật khẩu!"); return; }
                this.innerText = "Đang kiểm tra...";
                this.disabled = true;

                fetch('${pageContext.request.contextPath}/profile?action=verify_password&password=' + encodeURIComponent(pwd))
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.valid) {
                            emailVerified = true;
                            document.getElementById("isEmailVerified").value = "1";
                            document.getElementById("emailVerifyStatus").style.display = "block";
                            document.getElementById("btnConfirmEmail").style.display = "none";
                            document.getElementById("confirmPassword").style.display = "none";
                            updateSubmitButton();
                        } else {
                            alert("Mật khẩu không đúng!");
                            document.getElementById("btnConfirmEmail").innerText = "XÁC NHẬN ĐỔI EMAIL";
                            document.getElementById("btnConfirmEmail").disabled = false;
                        }
                    })
                    .catch(function() {
                        alert("Có lỗi xảy ra!");
                        document.getElementById("btnConfirmEmail").innerText = "XÁC NHẬN ĐỔI EMAIL";
                        document.getElementById("btnConfirmEmail").disabled = false;
                    });
            };

            document.getElementById("profilePhone").addEventListener('input', function() {
                if(this.value !== originalPhone && this.value.trim() !== "") {
                    document.getElementById("isPhoneVerified").value = "0";
                    document.getElementById("btnSendOTP").style.display = "block";
                    phoneVerified = false;
                } else {
                    document.getElementById("isPhoneVerified").value = "1";
                    document.getElementById("btnSendOTP").style.display = "none";
                    document.getElementById("otp-group").style.display = "none";
                    phoneVerified = true;
                }
                updateSubmitButton();
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
                    phoneVerified = true;
                    document.getElementById("isPhoneVerified").value = "1";
                    document.getElementById("otp-group").style.display = "none";
                    updateSubmitButton();
                }).catch(function (error) {
                    alert("Mã OTP không đúng!");
                });
            };
        </script>
    </body>
</html>
