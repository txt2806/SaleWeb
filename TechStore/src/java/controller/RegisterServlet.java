package controller;

import dao.UserDAO;
import util.EmailUtils;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy dữ liệu từ người dùng
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");

        // 2. Tạo mã OTP 6 số ngẫu nhiên
        String token = String.valueOf((int) ((Math.random() * 900000) + 100000));

        // 3. Lưu thông tin vào Database
        UserDAO dao = new UserDAO();
        boolean isSuccess = dao.registerWithToken(user, pass, email, token);
        
        if (!isSuccess) {
            request.setAttribute("error", "Tên đăng nhập hoặc Email đã tồn tại. Vui lòng chọn tên/email khác!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 4. Gửi Email chứa mã OTP
        EmailUtils.sendVerificationEmail(email, token);

        // 5. Lưu Email vào Session để trang Verify biết đang xác thực cho ai
        HttpSession session = request.getSession();
        session.setAttribute("emailVerify", email);

        // 6. Chuyển hướng người dùng sang trang nhập mã xác nhận
        response.sendRedirect("verify.jsp");
    }
}
