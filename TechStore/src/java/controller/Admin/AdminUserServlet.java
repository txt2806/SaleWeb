package controller.Admin;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

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

        UserDAO dao = new UserDAO();
        List<User> users = dao.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin_users.jsp").forward(request, response);
    }
}
