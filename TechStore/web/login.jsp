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

                    <c:if test="${param.registered == 'true'}">
                        <div style="background: #d4edda; color: #155724; padding: 10px; text-align: center; border-radius: 5px; margin-bottom: 15px; font-size: 14px;">
                            ✅ Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản trước khi đăng nhập.
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty unverifiedEmail}">
                        <div style="background:#e0f2fe; padding:12px; border-radius:8px; margin-bottom:15px; text-align:center;">
                            <p style="font-size:13px; color:#075985; margin-bottom:8px;">Nếu chưa nhận được email xác minh:</p>
                            <button type="button" id="btnResendVerify" class="auth-btn" style="background:#0ea5e9; margin-bottom:6px;">📧 GỬI LẠI EMAIL XÁC MINH</button>
                            <p style="font-size:12px; color:#666; margin-top:6px;">Đã xác minh rồi? 
                                <a href="#" id="btnCheckVerify" style="color:#d70018; font-weight:bold;">Bấm vào đây để kiểm tra</a>
                            </p>
                            <p id="resendStatus" style="display:none; font-size:13px; margin-top:8px;"></p>
                        </div>
                        <input type="hidden" id="unverifiedEmail" value="${unverifiedEmail}">
                    </c:if>

                    <button type="submit" class="auth-btn">Đăng nhập</button>
                </form>
                    <div style="text-align:center; margin: 15px 0; color: #666; font-size: 14px; position:relative;">
                        <span style="background:#fff; padding:0 10px; position:relative; z-index:1;">Hoặc đăng nhập bằng</span>
                        <div style="border-top: 1px solid #ddd; position:absolute; top:50%; width:100%; z-index:0;"></div>
                    </div>
                    
                    <button type="button" id="btnGoogle" class="auth-btn" style="background:#db4437; margin-bottom:10px; display:flex; align-items:center; justify-content:center; gap:10px;">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" width="20" height="20" style="background:white; border-radius:50%; padding:2px;">
                        Google
                    </button>
                
                <form id="socialLoginForm" action="social_login" method="post" style="display:none;">
                    <input type="hidden" name="email" id="socialEmail">
                    <input type="hidden" name="name" id="socialName">
                    <input type="hidden" name="uid" id="socialUid">
                </form>

                <div class="auth-links">
                    <p><a href="#" id="forgotPasswordLink" style="color:#d70018;">Quên mật khẩu?</a></p>
                    <p>Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
                </div>

                <div id="forgotPasswordBox" style="display:none; background:#f9f9f9; padding:15px; border-radius:8px; margin-top:10px; border:1px solid #eee;">
                    <p style="font-size:14px; color:#333; margin-bottom:10px;">Nhập email đã đăng ký để đặt lại mật khẩu:</p>
                    <input type="email" id="resetEmail" placeholder="Email" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:6px; margin-bottom:10px;">
                    <button type="button" id="btnResetPassword" class="auth-btn" style="background:#f59e0b;">GỬI EMAIL ĐẶT LẠI MẬT KHẨU</button>
                    <p id="resetStatus" style="display:none; font-size:13px; margin-top:8px;"></p>
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
                        appId: "1:858945999785:web:07d4d8cbd248ceb311eab8",
                        measurementId: "G-D04FD2NPH9"
                    };
                    if (firebase.apps.length === 0) {
                        firebase.initializeApp(firebaseConfig);
                    }

                    function submitSocialLogin(user) {
                        document.getElementById("socialEmail").value = user.email || (user.uid + "@social.com");
                        document.getElementById("socialName").value = user.displayName || "User_" + user.uid.substring(0, 5);
                        document.getElementById("socialUid").value = user.uid;
                        document.getElementById("socialLoginForm").submit();
                    }

                    document.getElementById("btnGoogle").addEventListener("click", function() {
                        var provider = new firebase.auth.GoogleAuthProvider();
                        firebase.auth().signInWithPopup(provider).then(function(result) {
                            submitSocialLogin(result.user);
                        }).catch(function(error) {
                            alert("Đăng nhập Google thất bại: " + error.message);
                        });
                    });

                    // Quên mật khẩu
                    document.getElementById("forgotPasswordLink").addEventListener("click", function(e) {
                        e.preventDefault();
                        var box = document.getElementById("forgotPasswordBox");
                        box.style.display = box.style.display === "none" ? "block" : "none";
                    });

                    document.getElementById("btnResetPassword").addEventListener("click", function() {
                        var email = document.getElementById("resetEmail").value.trim();
                        if (!email) { alert("Vui lòng nhập email!"); return; }
                        this.innerText = "Đang gửi...";
                        this.disabled = true;
                        var statusEl = document.getElementById("resetStatus");
                        
                        firebase.auth().sendPasswordResetEmail(email)
                            .then(function() {
                                statusEl.style.display = "block";
                                statusEl.style.color = "#155724";
                                statusEl.innerText = "✅ Email đặt lại mật khẩu đã được gửi! Kiểm tra hộp thư của bạn.";
                                document.getElementById("btnResetPassword").innerText = "ĐÃ GỬI";
                            })
                            .catch(function(error) {
                                statusEl.style.display = "block";
                                statusEl.style.color = "#dc2626";
                                if (error.code === "auth/user-not-found") {
                                    statusEl.innerText = "❌ Email không tồn tại trong hệ thống!";
                                } else {
                                    statusEl.innerText = "❌ Lỗi: " + error.message;
                                }
                                document.getElementById("btnResetPassword").innerText = "GỬI EMAIL ĐẶT LẠI MẬT KHẨU";
                                document.getElementById("btnResetPassword").disabled = false;
                            });
                    });

                    // Gửi lại / Kiểm tra xác minh email
                    (function() {
                        var emailEl = document.getElementById('unverifiedEmail');
                        if (!emailEl) return;
                        var email = emailEl.value;
                        var pwd = document.querySelector('input[name="password"]');

                        var btnResend = document.getElementById('btnResendVerify');
                        var btnCheck = document.getElementById('btnCheckVerify');
                        var statusEl = document.getElementById('resendStatus');

                        if (btnResend) {
                            btnResend.addEventListener('click', function() {
                                if (!pwd || !pwd.value) { alert("Vui lòng nhập mật khẩu vào form đăng nhập!"); return; }
                                this.innerText = "Đang gửi...";
                                this.disabled = true;
                                firebase.auth().signInWithEmailAndPassword(email, pwd.value)
                                    .then(function(cred) {
                                        return cred.user.sendEmailVerification().then(function() {
                                            statusEl.style.display = "block";
                                            statusEl.style.color = "#155724";
                                            statusEl.innerText = "✅ Email xác minh đã được gửi lại tới " + email + "! Hãy kiểm tra hộp thư.";
                                            btnResend.innerText = "ĐÃ GỬI";
                                        });
                                    })
                                    .catch(function(err) {
                                        statusEl.style.display = "block";
                                        statusEl.style.color = "#dc2626";
                                        statusEl.innerText = "❌ Lỗi: " + err.message;
                                        btnResend.innerText = "📧 GỬI LẠI EMAIL XÁC MINH";
                                        btnResend.disabled = false;
                                    });
                            });
                        }

                        if (btnCheck) {
                            btnCheck.addEventListener('click', function(e) {
                                e.preventDefault();
                                if (!pwd || !pwd.value) { alert("Vui lòng nhập mật khẩu vào form đăng nhập!"); return; }
                                statusEl.style.display = "block";
                                statusEl.style.color = "#075985";
                                statusEl.innerText = "Đang kiểm tra...";

                                firebase.auth().signInWithEmailAndPassword(email, pwd.value)
                                    .then(function(cred) {
                                        if (cred.user.emailVerified) {
                                            return fetch('${pageContext.request.contextPath}/login?action=verify_email&email=' + encodeURIComponent(email))
                                                .then(function() {
                                                    statusEl.style.color = "#155724";
                                                    statusEl.innerText = "✅ Email đã xác minh! Đang đăng nhập...";
                                                    document.querySelector('form.auth-form').submit();
                                                });
                                        } else {
                                            statusEl.style.color = "#dc2626";
                                            statusEl.innerText = "❌ Email chưa được xác minh. Hãy kiểm tra hộp thư và nhấn link xác minh.";
                                        }
                                    })
                                    .catch(function(err) {
                                        statusEl.style.color = "#dc2626";
                                        statusEl.innerText = "❌ Lỗi: " + err.message;
                                    });
                            });
                        }
                    })();
                </script>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>