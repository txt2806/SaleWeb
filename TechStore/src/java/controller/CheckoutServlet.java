package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import dao.OrderDAO;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        if (session.getAttribute("cart") == null) {
            response.sendRedirect("cart");
            return;
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");
        
        if (cart != null && user != null && !cart.isEmpty()) {
            double total = 0;
            List<OrderDetail> details = new ArrayList<>();
            for (CartItem item : cart) {
                total += item.getTotal();
                details.add(new OrderDetail(0, 0, item.getProduct().getId(), item.getProduct().getPrice(), item.getQuantity()));
            }
            
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");

            Order order = new Order(0, user.getId(), new Date(), total, "Completed", address, phone);
            OrderDAO dao = new OrderDAO();
            dao.createOrder(order, details);
        }

        session.removeAttribute("cart");

        response.sendRedirect("checkout_success.jsp");

    }
}
