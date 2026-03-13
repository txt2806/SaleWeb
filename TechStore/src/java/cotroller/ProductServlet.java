package controller;

import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Product;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();

        List<Product> list = dao.getAllProducts();

        request.setAttribute("data", list);

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}