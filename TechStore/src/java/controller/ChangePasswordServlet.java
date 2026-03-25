package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/change_password")
public class ChangePasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPass = request.getParameter("old_password");
        String newPass = request.getParameter("new_password");
        String confirmPass = request.getParameter("confirm_password");

        if (oldPass == null || newPass == null || confirmPass == null) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (!oldPass.equals(user.getPassword())) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới không khớp.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        dao.updatePassword(user.getId(), newPass);
        user.setPassword(newPass); // Cập nhật trong session
        
        request.setAttribute("success", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}
