package controller;

import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Product;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        List<Product> featuredList = dao.getFeaturedProducts();
        request.setAttribute("featuredList", featuredList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}