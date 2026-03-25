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

        // --- 1. LOGIC TÌM KIẾM VÀ LỌC SẢN PHẨM ---
        String minPriceStr = request.getParameter("min_price");
        String maxPriceStr = request.getParameter("max_price");
        String sortBy = request.getParameter("sort_by");

        Integer cateId = null;
        if (cateIdStr != null && !cateIdStr.isEmpty()) {
            try { cateId = Integer.parseInt(cateIdStr); } catch (Exception e) { }
            request.setAttribute("activeCategory", cateId);
        }

        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try { minPrice = Double.parseDouble(minPriceStr); } catch (Exception e) { }
            request.setAttribute("minPrice", minPriceStr);
        }

        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try { maxPrice = Double.parseDouble(maxPriceStr); } catch (Exception e) { }
            request.setAttribute("maxPrice", maxPriceStr);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            request.setAttribute("keyword", keyword);
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            request.setAttribute("sortBy", sortBy);
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (Exception e) {}
        }
        int pageSize = 9;

        int totalProducts = pDao.getTotalFilteredProducts(keyword, cateId, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        List<Product> listP = pDao.getFilteredProducts(keyword, cateId, minPrice, maxPrice, sortBy, page, pageSize);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // --- 2. LẤY DANH SÁCH DANH MỤC CHO THANH MENU ---
        List<Category> listC = cDao.getAllCategories();

        // --- 3. GỬI DỮ LIỆU SANG JSP ---
        request.setAttribute("data", listP);
        request.setAttribute("categories", listC);

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
    