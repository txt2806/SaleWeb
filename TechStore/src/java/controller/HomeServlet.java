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
        List<Product> list = dao.getFeaturedProducts();
     
        request.setAttribute("featuredProducts", list);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
