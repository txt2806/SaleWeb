<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dang nhap - TechStore</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <%@include file="header.jsp"%>

        <div class="auth-wrapper">
            <div class="auth-box">
                <div class="auth-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/295/295128.png" width="60" alt="Login Icon" style="opacity: 0.8;">
                </div>
                <h2 class="auth-title">Dang Nhap</h2>
                <p class="auth-subtitle">Chao mung ban tro lai voi TechStore</p>

                <form action="login" method="post" class="auth-form">
                    <div class="form-group">
                        <input type="text" name="username" placeholder="Ten dang nhap" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" placeholder="Mat khau" required>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            ${error}
                        </div>
                    </c:if>

                    <button type="submit" class="auth-btn">Dang nhap</button>
                </form>
                    <div style="text-align:center; margin: 15px 0; color: #666; font-size: 14px; position:relative;">
                        <span style="background:#fff; padding:0 10px; position:relative; z-index:1;">Hoac dang nhap bang</span>
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
                    <p>Chua co tai khoan? <a href="register.jsp">Dang ky ngay</a></p>
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
                            alert("Dang nhap Google that bai: " + error.message);
                        });
                    });
                </script>
            </div>
        </div>

        <%@include file="footer.jsp"%>

    </body>
</html>