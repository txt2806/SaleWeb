package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tránh lỗi khi gõ trực tiếp URL verify
        if (request.getSession().getAttribute("emailVerify") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("verify.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otpInput = request.getParameter("otp");
        String email = (String) request.getSession().getAttribute("emailVerify");

        UserDAO dao = new UserDAO();
        User u = dao.getUserByEmail(email);

        if (u != null && otpInput.equals(u.getToken())) {
            dao.verifyUser(email);
            request.getSession().removeAttribute("emailVerify");

            request.setAttribute("msg", "Xác thực thành công! Mời bạn đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Mã xác thực không đúng, vui lòng kiểm tra lại Email!");
            request.getRequestDispatcher("verify.jsp").forward(request, response);
        }
    }
}
