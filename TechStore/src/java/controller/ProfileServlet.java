package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("verify_password".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            User user = (User) request.getSession().getAttribute("user");
            String password = request.getParameter("password");
            if (user == null || password == null) {
                response.getWriter().print("{\"valid\":false}");
                return;
            }
            UserDAO dao = new UserDAO();
            User check = dao.login(user.getUsername(), password);
            response.getWriter().print(check != null ? "{\"valid\":true}" : "{\"valid\":false}");
            return;
        }
        response.sendRedirect("profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String avatar = request.getParameter("avatar");
        String isEmailVerified = request.getParameter("isEmailVerified");
        String isPhoneVerified = request.getParameter("isPhoneVerified");

        if (email != null && email.trim().isEmpty()) email = null;
        if (phone != null && phone.trim().isEmpty()) phone = null;

        UserDAO dao = new UserDAO();

        // Kiểm tra trùng email (trừ chính user hiện tại)
        if (dao.isEmailExists(email, user.getId())) {
            response.sendRedirect("profile.jsp?error=email_exists");
            return;
        }

        // Kiểm tra trùng SĐT (trừ chính user hiện tại)
        if (dao.isPhoneExists(phone, user.getId())) {
            response.sendRedirect("profile.jsp?error=phone_exists");
            return;
        }

        String sql = "UPDATE Users SET username=?, email=?, phone=?, avatar=?, is_verified=? WHERE id=?";
        try {
            java.sql.PreparedStatement st = dao.connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, email);
            st.setString(3, phone);
            st.setString(4, avatar);

            int verifiedStatus = ("1".equals(isEmailVerified) && "1".equals(isPhoneVerified)) ? 1 : 0;
            st.setInt(5, verifiedStatus);
            st.setInt(6, user.getId());
            st.executeUpdate();

            // Cập nhật session
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAvatar(avatar);
            user.setIsVerified(verifiedStatus);
            request.getSession().setAttribute("user", user);

            response.sendRedirect("profile.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=1");
        }
    }
}
