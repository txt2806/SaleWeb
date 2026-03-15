<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="css/style.css">

<div class="navbar">

    <div class="logo">TechStore</div>

    <div class="nav-links">

        <a href="index.jsp">Home</a>
        <a href="products">Products</a>

        <c:choose>

            <c:when test="${sessionScope.user != null}">

                Welcome ${sessionScope.user.username}

                <a href="cart">
                    Cart (${sessionScope.cart.size()})
                </a>

                <a href="logout">Logout</a>

            </c:when>

            <c:otherwise>

                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>

            </c:otherwise>

        </c:choose>

    </div>

</div>