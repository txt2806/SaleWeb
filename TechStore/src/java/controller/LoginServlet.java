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
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User u = dao.login(user, pass);

        if (u == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Kiểm tra xem đã xác thực email chưa
            if (u.getIsVerified() == 0 && u.getRole() == 0) {
                request.getSession().setAttribute("emailVerify", u.getEmail());
                request.setAttribute("error", "Tài khoản của bạn chưa được kích hoạt qua Email!");
                request.getRequestDispatcher("verify.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("user", u);
                response.sendRedirect("home");
            }
        }
    }
}
