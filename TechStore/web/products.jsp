<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="css/style.css">

<div class="navbar">

<div class="logo">TechStore</div>

<div class="nav-links">
<a href="index.jsp">Home</a>
<a href="login.jsp">Login</a>
</div>

</div>

<div class="container">

<h2 class="title">Technology Products</h2>

<div class="product-grid">

<c:forEach items="${data}" var="p">

<div class="product-card">

<img src="https://cdn-icons-png.flaticon.com/512/1041/1041372.png">

<div class="product-name">${p.name}</div>

<div class="price">$${p.price}</div>

<p>${p.description}</p>

<button class="btn">Add to Cart</button>

</div>

</c:forEach>

</div>

</div>