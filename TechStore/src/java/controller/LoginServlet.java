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
            // Auto-verify legacy users since Email OTP is removed
            if (u.getIsVerified() == 0 && u.getRole() == 0) {
                dao.verifyUser(u.getEmail());
                u.setIsVerified(1);
            }
            request.getSession().setAttribute("user", u);
            response.sendRedirect("home");
        }
    }
}
