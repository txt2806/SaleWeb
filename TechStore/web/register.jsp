<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>ÄÄƒng kĂ½ - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-wrapper">
            <div class="auth-box">
                <div class="auth-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/3596/3596091.png" width="60" alt="Register Icon" style="opacity: 0.8;">
                </div>
                <h2 class="auth-title">ÄÄƒng KĂ½</h2>
                <p class="auth-subtitle">Táº¡o tĂ i khoáº£n Ä‘á»ƒ nháº­n nhiá»u Æ°u Ä‘Ă£i</p>

                <form action="register" method="post" class="auth-form" id="registerForm">
                    <div style="display:flex; margin-bottom: 15px;">
                        <button type="button" id="tabEmail" style="flex:1; padding:10px; border:1px solid #ccc; background:#fff; cursor:pointer; font-weight:bold; border-bottom:2px solid #e67e22; color:#e67e22;">Qua Email</button>
                        <button type="button" id="tabPhone" style="flex:1; padding:10px; border:1px solid #ccc; background:#f9f9f9; cursor:pointer; color:#333;">Qua SĐT</button>
                    </div>

                    <div class="form-group">
                        <input type="text" name="username" id="regUser" placeholder="Tên đăng nhập" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" id="regPass" placeholder="Mật khẩu" required>
                    </div>
                    
                    <div class="form-group" id="groupEmail">
                        <input type="email" name="email" id="regEmail" placeholder="Địa chỉ Email" required>
                    </div>
                    <div class="form-group" id="groupPhone" style="display:none;">
                        <input type="text" name="phone" id="regPhone" placeholder="Số điện thoại (+84...)">
                    </div>

                    <input type="hidden" name="isVerified" id="isVerifiedFlag" value="0">

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            ⚠️ ${error}
                        </div>
                    </c:if>

                    <div id="recaptcha-container"></div>
                    <div class="form-group" id="otp-group" style="display:none; margin-top:10px;">
                        <input type="text" id="otp" placeholder="Nhập mã OTP từ SMS">
                        <button type="button" id="btnVerifyOTP" class="auth-btn" style="background:#4ade80; margin-top:5px;">XÁC NHẬN OTP</button>
                    </div>

                    <button type="button" id="btnSubmitEmail" class="auth-btn" style="margin-top:10px;">ĐĂNG KÝ BẰNG EMAIL</button>
                    <button type="button" id="btnSendOTP" class="auth-btn" style="background:#f59e0b; margin-top:10px; display:none;">GỬI OTP TỚI SĐT</button>
                    <button type="submit" id="btnSubmit" style="display:none;"></button>
                </form>

                <div style="text-align:center; margin: 15px 0; color: #666; font-size: 14px; position:relative;">
                    <span style="background:#fff; padding:0 10px; position:relative; z-index:1;">Hoặc đăng ký bằng</span>
                    <div style="border-top: 1px solid #ddd; position:absolute; top:50%; width:100%; z-index:0;"></div>
                </div>
                
                <button type="button" id="btnGoogleReg" class="auth-btn" style="background:#db4437; margin-bottom:10px; display:flex; align-items:center; justify-content:center; gap:10px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" width="20" height="20" style="background:white; border-radius:50%; padding:2px;">
                    Google
                </button>
                <button type="button" id="btnFacebookReg" class="auth-btn" style="background:#4267B2; margin-bottom:15px; display:flex; align-items:center; justify-content:center; gap:10px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/2021_Facebook_icon.svg" width="20" height="20">
                    Facebook
                </button>

                <form id="socialRegForm" action="social_login" method="post" style="display:none;">
                    <input type="hidden" name="email" id="socialRegEmail">
                    <input type="hidden" name="name" id="socialRegName">
                    <input type="hidden" name="uid" id="socialRegUid">
                </form>
                
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

                    // TABS LOGIC
                    let currentMode = "email";
                    document.getElementById("tabEmail").onclick = function() {
                        currentMode = "email";
                        this.style.background = "#fff"; this.style.borderBottom = "2px solid #e67e22"; this.style.color = "#e67e22";
                        document.getElementById("tabPhone").style.background = "#f9f9f9"; document.getElementById("tabPhone").style.borderBottom = "1px solid #ccc"; document.getElementById("tabPhone").style.color = "#333";
                        document.getElementById("groupEmail").style.display = "block"; document.getElementById("regEmail").required = true;
                        document.getElementById("groupPhone").style.display = "none"; document.getElementById("regPhone").required = false; document.getElementById("regPhone").value = "";
                        document.getElementById("btnSubmitEmail").style.display = "block";
                        document.getElementById("btnSendOTP").style.display = "none";
                        document.getElementById("otp-group").style.display = "none";
                    };
                    document.getElementById("tabPhone").onclick = function() {
                        currentMode = "phone";
                        this.style.background = "#fff"; this.style.borderBottom = "2px solid #e67e22"; this.style.color = "#e67e22";
                        document.getElementById("tabEmail").style.background = "#f9f9f9"; document.getElementById("tabEmail").style.borderBottom = "1px solid #ccc"; document.getElementById("tabEmail").style.color = "#333";
                        document.getElementById("groupPhone").style.display = "block"; document.getElementById("regPhone").required = true;
                        document.getElementById("groupEmail").style.display = "none"; document.getElementById("regEmail").required = false; document.getElementById("regEmail").value = "";
                        document.getElementById("btnSubmitEmail").style.display = "none";
                        document.getElementById("btnSendOTP").style.display = "block";
                    };

                    document.addEventListener("DOMContentLoaded", function () {
                        if(typeof firebase !== "undefined" && firebase.apps.length > 0) {
                            window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier("recaptcha-container", { "size": "invisible" });
                        }
                    });

                    // FIREBASE EMAIL REGISTRATION
                    document.getElementById("btnSubmitEmail").onclick = function() {
                        if(!document.getElementById("registerForm").checkValidity()) {
                            document.getElementById("registerForm").reportValidity();
                            return;
                        }
                        const email = document.getElementById("regEmail").value;
                        const pass = document.getElementById("regPass").value;
                        
                        document.getElementById("btnSubmitEmail").innerText = "Đang xử lý...";
                        document.getElementById("btnSubmitEmail").disabled = true;

                        firebase.auth().createUserWithEmailAndPassword(email, pass)
                            .then(function(userCredential) {
                                userCredential.user.sendEmailVerification().then(function() {
                                    alert("Đăng ký Firebase thành công! Một Email xác minh vừa được gửi tới " + email);
                                    document.getElementById("isVerifiedFlag").value = "0";
                                    document.getElementById("btnSubmit").click();
                                });
                            })
                            .catch(function(error) {
                                alert("Lỗi Firebase: " + error.message);
                                document.getElementById("btnSubmitEmail").innerText = "ĐĂNG KÝ BẰNG EMAIL";
                                document.getElementById("btnSubmitEmail").disabled = false;
                            });
                    };

                    // FIREBASE PHONE REGISTRATION
                    document.getElementById("btnSendOTP").onclick = function() {
                        if(!document.getElementById("registerForm").checkValidity()) {
                            document.getElementById("registerForm").reportValidity();
                            return;
                        }
                        const phone = document.getElementById("regPhone").value;
                        if(!phone.startsWith("+84") && phone.startsWith("0")) {
                            alert("Vui lòng nhập số điện thoại định dạng +84 (VD: +84912345678)");
                            return;
                        }
                        document.getElementById("btnSendOTP").innerText = "Đang gửi SMS...";
                        firebase.auth().signInWithPhoneNumber(phone, window.recaptchaVerifier)
                            .then(function (confirmationResult) {
                                window.confirmationResult = confirmationResult;
                                document.getElementById("otp-group").style.display = "block";
                                document.getElementById("btnSendOTP").style.display = "none";
                                alert("Đã gửi mã OTP!");
                            }).catch(function (error) {
                                alert("Lỗi khi gửi SMS: " + error.message);
                                document.getElementById("btnSendOTP").innerText = "GỬI OTP TỚI SĐT";
                            });
                    };

                    document.getElementById("btnVerifyOTP").onclick = function() {
                        const code = document.getElementById("otp").value;
                        confirmationResult.confirm(code).then(function (result) {
                            alert("Xác thực SĐT thành công!");
                            document.getElementById("isVerifiedFlag").value = "1";
                            document.getElementById("btnSubmit").click();
                        }).catch(function (error) {
                            alert("Mã OTP không đúng!");
                        });
                    };

                    function submitSocialReg(user) {
                        document.getElementById("socialRegEmail").value = user.email || (user.uid + "@facebook.com");
                        document.getElementById("socialRegName").value = user.displayName || "User_" + user.uid.substring(0, 5);
                        document.getElementById("socialRegUid").value = user.uid;
                        document.getElementById("socialRegForm").submit();
                    }

                    document.getElementById("btnGoogleReg").addEventListener("click", function() {
                        var provider = new firebase.auth.GoogleAuthProvider();
                        firebase.auth().signInWithPopup(provider).then(function(result) { submitSocialReg(result.user); })
                        .catch(function(error) { alert("Đăng nhập Google thất bại: " + error.message); });
                    });
                    document.getElementById("btnFacebookReg").addEventListener("click", function() {
                        var provider = new firebase.auth.FacebookAuthProvider();
                        firebase.auth().signInWithPopup(provider).then(function(result) { submitSocialReg(rup(provider).then(function(result) {
                            submitSocialReg(result.user);
                        }).catch(function(error) {
                            alert("ÄÄƒng nháº­p Facebook tháº¥t báº¡i: " + error.message);
                        });
                    });
                </script>

                <div class="auth-links">
                    ÄĂ£ cĂ³ tĂ i khoáº£n? <a href="login.jsp">ÄÄƒng nháº­p ngay</a>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>