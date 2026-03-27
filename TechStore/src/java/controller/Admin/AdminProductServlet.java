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

            request.setAttribute("productToEdit", p);
            request.getRequestDispatcher("/edit_product.jsp").forward(request, response);
            return;
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

        // --- Batch actions (no file upload) ---
        if ("update_featured_batch".equals(action)) {
            String[] featuredIds = request.getParameterValues("featuredIds");
            dao.updateFeaturedBatch(featuredIds);
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            return;
        }
        if ("update_stock_batch".equals(action)) {
            String[] ids = request.getParameterValues("stockProductId");
            String[] stocks = request.getParameterValues("stockValue");
            if (ids != null && stocks != null) {
                for (int i = 0; i < ids.length; i++) {
                    dao.updateStock(Integer.parseInt(ids[i]), Integer.parseInt(stocks[i]));
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            return;
        }

        // --- Add/Edit product (with file upload) ---
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String desc = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        boolean isFeatured = request.getParameter("is_featured") != null;

        String imagePath = "";
        Part filePart = request.getPart("imageFile");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = "d:" + File.separator + "SE" + File.separator + "SPRING2026" + File.separator + "PRJ301" + File.separator + "SaleWeb" + File.separator + "SaleWeb" + File.separator + "TechStore" + File.separator + "web" + File.separator + "images" + File.separator + "products";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            fileName = System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "images/products/" + fileName;
        }

        if ("add".equals(action)) {
            Product p = new Product(0, name, price, desc, imagePath, categoryId, isFeatured, false, 0, 5, new java.util.Date(), new java.util.Date());
            dao.addProduct(p);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product existing = dao.getProductById(id);
            int currentStock = (existing != null) ? existing.getStock() : 5;
            Product p = new Product(id, name, price, desc, imagePath, categoryId, isFeatured, false, 0, currentStock, new java.util.Date(), new java.util.Date());
            dao.updateProduct(p);
        }

        response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
    }
}
