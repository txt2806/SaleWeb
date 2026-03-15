package controller.Admin;

import dao.ProductDAO;
import model.Product;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin/product")
public class AdminProductServlet extends HttpServlet {

    // Hàm kiểm tra bảo mật: Phải là Role 1 mới được vào
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String desc = request.getParameter("description");
        String img = request.getParameter("image");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        boolean isFeatured = request.getParameter("is_featured") != null;

        if ("add".equals(action)) {
            Product p = new Product(0, name, price, desc, img, categoryId, isFeatured);
            dao.addProduct(p);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = new Product(id, name, price, desc, img, categoryId, isFeatured);
            dao.updateProduct(p);
        }

        response.sendRedirect(request.getContextPath() + "/products"); // Quay lại trang sản phẩm
    }
}