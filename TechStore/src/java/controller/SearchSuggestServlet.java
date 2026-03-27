package controller;

import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Product;

@WebServlet("/search-suggest")
public class SearchSuggestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        PrintWriter out = response.getWriter();

        if (keyword == null || keyword.trim().isEmpty()) {
            out.print("[]");
            return;
        }

        ProductDAO dao = new ProductDAO();
        List<Product> suggestions = dao.searchSuggestions(keyword.trim(), 8);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < suggestions.size(); i++) {
            Product p = suggestions.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\":").append(p.getId()).append(",");
            json.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
            json.append("\"price\":").append(p.getPrice()).append(",");
            json.append("\"image\":\"").append(escapeJson(p.getImage() != null ? p.getImage() : "")).append("\"");
            json.append("}");
        }
        json.append("]");

        out.print(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
