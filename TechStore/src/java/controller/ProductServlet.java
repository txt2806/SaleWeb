package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();

        String keyword = request.getParameter("keyword");

        List<Product> list;

        if (keyword == null || keyword.trim().equals("")) {

            list = dao.getAllProducts();

        } else {

            list = dao.search(keyword);

        }

        request.setAttribute("data", list);

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}