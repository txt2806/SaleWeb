package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/social_login")
public class SocialLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String uid = request.getParameter("uid"); // Dùng uid làm password nội bộ

        if (email == null || uid == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        User u = dao.getUserByEmail(email);

        if (u == null) {
            // Đăng ký tự động nếu người dùng chưa tồn tại
            boolean success = dao.registerVerifiedUser(name, uid, email, "");
            if (success) {
                u = dao.getUserByEmail(email);
            }
        } else {
            // Update the verified status to 1 if it wasn't
            if (u.getIsVerified() == 0) {
                dao.verifyUser(u.getEmail());
                u.setIsVerified(1);
            }
        }

        if (u != null) {
            request.getSession().setAttribute("user", u);
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Lỗi server khi đăng nhập bằng Mạng xã hội");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
