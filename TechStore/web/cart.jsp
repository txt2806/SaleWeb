<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<link rel="stylesheet" href="css/style.css">
<%@include file="header.jsp"%>

<div class="cart-page">

    <div class="cart-header">
        <a href="javascript:history.back()" class="back-btn">&#8592;</a>
        <h2 class="cart-title">Giỏ hàng của bạn</h2>
    </div>

    <c:choose>
        <%-- Kiểm tra nếu giỏ hàng trống --%>
        <c:when test="${empty sessionScope.cart || sessionScope.cart.size() == 0}">
            <div class="empty-cart">
                <img src="https://cdn-icons-png.flaticon.com/512/2038/2038854.png" width="120">
                <p>Giỏ hàng của bạn đang trống</p>
                <a href="products">
                    <button class="btn">Quay lại mua sắm</button>
                </a>
            </div>
        </c:when>

        <%-- Nếu có sản phẩm trong giỏ hàng --%>
        <c:otherwise>
            <c:set var="total" value="0"/>

            <div class="cart-select-all">
                <input type="radio" id="selectAll">
                <label for="selectAll">Chọn tất cả</label>
            </div>

            <div class="cart-list">
                <c:forEach items="${sessionScope.cart}" var="item">
                    <div class="cart-item">

                        <div class="item-checkbox">
                            <input type="radio" name="selectedItem">
                        </div>

                        <%-- Hiển thị ảnh sản phẩm --%>
                        <img class="cart-img" src="${item.product.image}" alt="${item.product.name}">

                        <div class="cart-info">
                            <div class="cart-name">
                                ${item.product.name}
                            </div>
                            <div class="cart-price-box">
                                <%-- Định dạng lại giá tiền để tránh lỗi 1.599E7 --%>
                                <span class="cart-price">
                                    <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>đ
                                </span>
                            </div>
                        </div>

                        <%-- Nút xóa sản phẩm --%>
                        <div class="cart-remove">
                            <form action="cart" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="id" value="${item.product.id}">
                                <button class="remove-btn">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M10 11v6M14 11v6"/>
                                    </svg>
                                </button>
                            </form>
                        </div>

                        <%-- Bộ điều khiển số lượng --%>
                        <div class="cart-qty">
                            <form action="cart" method="post" style="margin: 0; display: flex;">
                                <input type="hidden" name="action" value="decrease">
                                <input type="hidden" name="id" value="${item.product.id}">
                                <button class="qty-btn">-</button>
                            </form>

                            <span class="qty-val">${item.quantity}</span>

                            <form action="cart" method="post" style="margin: 0; display: flex;">
                                <input type="hidden" name="action" value="increase">
                                <input type="hidden" name="id" value="${item.product.id}">
                                <button class="qty-btn">+</button>
                            </form>
                        </div>

                    </div>
                    <%-- Tính toán tổng tiền tạm tính --%>
                    <c:set var="total" value="${total + (item.product.price * item.quantity)}"/>
                </c:forEach>
            </div>

            <%-- Phần tổng kết giỏ hàng --%>
            <div class="cart-summary-wrapper">
                <div class="cart-summary">
                    <div class="cart-total">
                        Tạm tính: <b><fmt:formatNumber value="${total}" pattern="#,###"/>đ</b>
                    </div>

                    <%-- Nút chuyển sang trang điền thông tin thanh toán (checkout.jsp) --%>
                    <a href="checkout" style="text-decoration: none;">
                        <button type="button" class="checkout-btn ${total == 0 ? 'disabled' : ''}" ${total == 0 ? 'disabled' : ''}>
                            Mua ngay
                        </button>
                    </a>
                </div>
            </div>

        </c:otherwise>
    </c:choose>

</div>

<%@include file="footer.jsp"%>