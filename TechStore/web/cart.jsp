<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h2>Your Cart</h2>

<table border="1">

    <tr>
        <th>Product</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
    </tr>

    <c:set var="total" value="0"/>

    <c:forEach items="${sessionScope.cart}" var="c">

        <tr>

            <td>${c.product.name}</td>

            <td>$${c.product.price}</td>

            <td>${c.quantity}</td>

            <td>$${c.total}</td>

        </tr>

        <c:set var="total" value="${total + c.total}"/>

    </c:forEach>

</table>

<h3>Total: $${total}</h3>

<br>

<a href="products">
    <button>Continue Shopping</button>
</a>

<a href="checkout.jsp">
    <button>Checkout</button>
</a>
