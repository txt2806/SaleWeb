<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="css/style.css">

<div class="navbar">

    <div class="logo">TechStore</div>

    <div class="nav-links">

        <a href="index.jsp">Home</a>
        <a href="products">Products</a>

        <c:choose>

            <c:when test="${sessionScope.user != null}">
                Welcome ${sessionScope.user.username}
                <a href="cart">Cart</a>
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

    <h2 class="title">Technology Products</h2>

    <!-- SEARCH -->
    <form action="products" method="get" style="margin-bottom:20px">

        <input type="text" name="keyword" placeholder="Search product">

        <button class="btn">Search</button>

    </form>


    <div class="product-grid">

        <c:forEach items="${data}" var="p">

            <div class="product-card">

                <img src="https://cdn-icons-png.flaticon.com/512/1041/1041372.png">

                <div class="product-name">${p.name}</div>

                <div class="price">$${p.price}</div>

                <p>${p.description}</p>


                <!-- ADD TO CART -->
                <c:choose>

                    <c:when test="${sessionScope.user != null}">

                        <form action="cart" method="post">

                            <input type="hidden" name="id" value="${p.id}">

                            <button class="btn">Add to Cart</button>

                        </form>

                    </c:when>

                    <c:otherwise>

                        <a href="login.jsp">
                            <button class="btn">Login to Buy</button>
                        </a>

                    </c:otherwise>

                </c:choose>


            </div>

        </c:forEach>

    </div>

</div>