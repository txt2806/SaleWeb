package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("check_verify".equals(action)) {
            // AJAX: trả về email của user để frontend check Firebase
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String username = request.getParameter("username");
            UserDAO dao = new UserDAO();
            // Find email by username
            String email = dao.getEmailByUsername(username);
            response.getWriter().print("{\"email\":" + (email != null ? "\"" + email + "\"" : "null") + "}");
            return;
        }
        if ("verify_email".equals(action)) {
            // AJAX: sync Firebase verified → DB
            String email = request.getParameter("email");
            if (email != null) {
                UserDAO dao = new UserDAO();
                dao.verifyUser(email);
            }
            response.setContentType("application/json");
            response.getWriter().print("{\"ok\":true}");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username") != null ? request.getParameter("username").trim() : null;
        String pass = request.getParameter("password") != null ? request.getParameter("password").trim() : null;

        UserDAO dao = new UserDAO();
        User u = dao.login(user, pass);

        if (u == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if (u.getIsVerified() == 0 && u.getRole() == 0) {
            // Chặn đăng nhập nếu chưa xác minh email
            request.setAttribute("error", "Tài khoản chưa được xác minh. Vui lòng kiểm tra email để xác minh tài khoản.");
            request.setAttribute("unverifiedEmail", u.getEmail());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("user", u);
            response.sendRedirect("home");
        }
    }
}
