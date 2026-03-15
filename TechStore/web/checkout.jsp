<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<h2>Checkout</h2>

<c:set var="total" value="0"/>

<c:forEach items="${sessionScope.cart}" var="c">

    <p>
        ${c.product.name} - $${c.total}
    </p>

    <c:set var="total" value="${total + c.total}"/>

</c:forEach>

<h2>Total Payment: $${total}</h2>

<form action="checkout" method="post">

    <input type="text" name="address" placeholder="Your Address">

    <br><br>

    <button>Confirm Order</button>

</form>
