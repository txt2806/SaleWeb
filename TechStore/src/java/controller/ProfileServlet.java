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
        String isEmailVerified = request.getParameter("isEmailVerified"); // 1 if unchanged or verified
        String isPhoneVerified = request.getParameter("isPhoneVerified"); // 1 if unchanged or verified

        UserDAO dao = new UserDAO();
        
        // Update fields safely
        String sql = "UPDATE Users SET username=?, email=?, phone=?, avatar=?, is_verified=? WHERE id=?";
        try {
            java.sql.PreparedStatement st = dao.connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, email);
            st.setString(3, phone);
            st.setString(4, avatar);
            
            // If they changed email and didn't verify, we set is_verified to 0. 
            // Better yet, if either is 0, we can set is_verified = 0.
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
