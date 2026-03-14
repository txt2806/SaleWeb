package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import model.Product;
import model.User;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // kiểm tra login
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        int id = Integer.parseInt(request.getParameter("id"));

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

        response.sendRedirect("cart");
    }
}