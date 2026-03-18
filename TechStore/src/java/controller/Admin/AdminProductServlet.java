package controller.Admin;

import dao.ProductDAO;
import model.Product;
import model.User;
import java.io.File;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/admin/product")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminProductServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        if ("prepare_edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = dao.getProductById(id);

            // Đẩy dữ liệu sản phẩm sang trang sửa
            request.setAttribute("productToEdit", p);
            request.getRequestDispatcher("/edit_product.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteProduct(id);
        } else if ("toggle_feature".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.toggleFeatured(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String desc = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        boolean isFeatured = request.getParameter("is_featured") != null;

        String imagePath = "";
        Part filePart = request.getPart("imageFile");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            fileName = System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "images/" + fileName;
        }

        if ("add".equals(action)) {
            Product p = new Product(0, name, price, desc, imagePath, categoryId, isFeatured, 0);
            dao.addProduct(p);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = new Product(id, name, price, desc, imagePath, categoryId, isFeatured, 0);
            dao.updateProduct(p);
        }

        response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
    }
}
