package controller.Admin;

import dao.OrderDAO;
import model.Order;
import model.OrderDetail;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

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
        OrderDAO dao = new OrderDAO();

        if ("view_detail".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            List<OrderDetail> details = dao.getOrderDetails(orderId);
            request.setAttribute("details", details);
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("/admin_order_detail.jsp").forward(request, response);
        } else {
            List<Order> orders = dao.getAllOrders();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin_orders.jsp").forward(request, response);
        }
    }
}
