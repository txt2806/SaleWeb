<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="css/style.css">

<div class="navbar">

    <div class="logo">TechStore</div>

    <div class="nav-links">

        <a href="products">Products</a>

        <c:choose>

            <c:when test="${sessionScope.user != null}">
                Welcome ${sessionScope.user.username}
                <a href="logout">Logout</a>
            </c:when>

            <c:otherwise>
                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>
            </c:otherwise>

        </c:choose>

    </div>

</div>


<div class="container">

    <h1 class="title">Welcome to TechStore</h1>

    <p>Best place to buy technology products.</p>

</div>


<div class="hero">
    <div class="hero-text">
        <h1>Latest Technology</h1>
        <p>Discover the best laptops, keyboards and gaming gear.</p>
        <a href="products" class="btn">Shop Now</a>
    </div>
</div>


<div class="container">

    <h2 class="title">Categories</h2>

    <div class="category">

        <a href="products?category=laptop" class="cat-card">💻 Laptop</a>

        <a href="products?category=keyboard" class="cat-card">⌨ Keyboard</a>

        <a href="products?category=mouse" class="cat-card">🖱 Mouse</a>

        <a href="products?category=monitor" class="cat-card">🖥 Monitor</a>

    </div>

</div>


<div class="container">

    <h2 class="title">Featured Products</h2>

    <div class="product-grid">

        <div class="product-card">
            <img src="https://cdn-icons-png.flaticon.com/512/1041/1041372.png">
            <div class="product-name">Gaming Laptop</div>
            <div class="price">$1500</div>
            <button class="btn">Buy Now</button>
        </div>

        <div class="product-card">
            <img src="https://cdn-icons-png.flaticon.com/512/3595/3595455.png">
            <div class="product-name">Mechanical Keyboard</div>
            <div class="price">$120</div>
            <button class="btn">Buy Now</button>
        </div>

    </div>

</div>


<footer class="footer">

    <p>© 2026 TechStore</p>
    <p>Contact: techstore@email.com</p>

</footer>