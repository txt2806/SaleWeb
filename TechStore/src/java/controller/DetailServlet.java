package controller;

import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Product;

@WebServlet("/detail")
public class DetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductDAO dao = new ProductDAO();
        Product p = dao.getProductById(id);
        request.setAttribute("product", p);
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }
}
