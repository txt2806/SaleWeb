package controller;

import dao.UserDAO;

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
        String phone = request.getParameter("phone");
        String isVerifiedParam = request.getParameter("isVerified");
        boolean isVerified = "1".equals(isVerifiedParam);

        if (email != null && email.trim().isEmpty()) email = null;
        if (phone != null && phone.trim().isEmpty()) phone = null;

        UserDAO dao = new UserDAO();
        boolean isSuccess;
        if (isVerified) {
            isSuccess = dao.registerVerifiedUser(user, pass, email, phone);
        } else {
            isSuccess = dao.registerUnverifiedUser(user, pass, email, phone);
        }
        
        if (!isSuccess) {
            request.setAttribute("error", "Tên đăng nhập, Email hoặc SĐT đã tồn tại. Vui lòng chọn thông tin khác!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Chuyển hướng người dùng sang trang đăng nhập sau khi đăng ký thành công
        response.sendRedirect("login.jsp?registered=true");
    }
}
