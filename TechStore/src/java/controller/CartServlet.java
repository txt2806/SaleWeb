package controller;

import dao.ProductDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.CartItem;
import model.Product;
import model.User;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Yêu cầu đăng nhập mới được mua hàng
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        int id = Integer.parseInt(request.getParameter("id"));

        if ("add".equals(action)) {
            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);
            boolean exist = false;
            for (CartItem item : cart) {
                if (item.getProduct().getId() == id) {
                    item.setQuantity(item.getQuantity() + 1);
                    exist = true;
                    break;
                }
            }
            if (!exist) {
                cart.add(new CartItem(p, 1));
            }

            session.setAttribute("cart", cart);

            // FIX LỖI NHẢY TRANG: Trả người dùng về đúng trang họ vừa đứng thay vì bắt buộc vào giỏ hàng
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "products");
            return;

        } else if ("increase".equals(action)) {
            for (CartItem item : cart) {
                if (item.getProduct().getId() == id) {
                    item.setQuantity(item.getQuantity() + 1);
                }
            }
        } else if ("decrease".equals(action)) {
            for (CartItem item : cart) {
                if (item.getProduct().getId() == id && item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                }
            }
        } else if ("remove".equals(action)) {
            cart.removeIf(item -> item.getProduct().getId() == id);
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart");
    }
}
