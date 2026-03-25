package controller.Admin;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin/reset_password")
public class ResetPasswordServlet extends HttpServlet {

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

        int userId = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        User targetUser = dao.getUserById(userId);
        
        if (targetUser != null && targetUser.getRole() != 1) { // Không cho reset admin
            dao.updatePassword(userId, "123456");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
