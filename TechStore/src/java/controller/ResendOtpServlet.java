package controller;

import dao.UserDAO;
import model.User;
import util.EmailUtils;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("resend_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User u = dao.getUserByEmail(email);

        if (u != null) {
            if (u.getIsVerified() == 1) {
                request.setAttribute("error", "Tài khoản của bạn đã được xác minh. Vui lòng đăng nhập.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Generate and update token
            String newToken = String.valueOf((int) ((Math.random() * 900000) + 100000));
            dao.updateToken(email, newToken);
            EmailUtils.sendVerificationEmail(email, newToken);
            
            request.getSession().setAttribute("emailVerify", email);
            request.setAttribute("msg", "Một mã xác thực mới đã được gửi tới Email của bạn.");
            request.getRequestDispatcher("verify.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không tìm thấy tài khoản với Email này.");
            request.getRequestDispatcher("resend_otp.jsp").forward(request, response);
        }
    }
}
