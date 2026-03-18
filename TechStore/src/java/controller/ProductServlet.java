package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Category;
import model.Product;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Khởi tạo các DAO cần thiết
        ProductDAO pDao = new ProductDAO();
        CategoryDAO cDao = new CategoryDAO();

        // Lấy các tham số từ URL
        String keyword = request.getParameter("keyword");
        String cateIdStr = request.getParameter("category_id");

        List<Product> listP;

        // --- 1. LOGIC TÌM KIẾM VÀ LỌC SẢN PHẨM ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nếu người dùng nhập từ khóa tìm kiếm
            listP = pDao.search(keyword);
            request.setAttribute("keyword", keyword); // Giữ lại từ khóa trên ô input

        } else if (cateIdStr != null && !cateIdStr.isEmpty()) {
            // Nếu người dùng bấm vào một danh mục
            int cateId = Integer.parseInt(cateIdStr);
            listP = pDao.getProductsByCategory(cateId);
            request.setAttribute("activeCategory", cateId); // Đánh dấu danh mục đang chọn

        } else {
            // Mặc định hiển thị tất cả sản phẩm
            listP = pDao.getAllProducts();
        }

        // --- 2. LẤY DANH SÁCH DANH MỤC CHO THANH MENU ---
        List<Category> listC = cDao.getAllCategories();

        // --- 3. GỬI DỮ LIỆU SANG JSP ---
        request.setAttribute("data", listP);
        request.setAttribute("categories", listC);

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
    