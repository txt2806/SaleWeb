package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();

        // kiểm tra username tồn tại
        if (dao.checkUserExist(user)) {

            request.setAttribute("error", "Username already exists!");

            request.getRequestDispatcher("register.jsp").forward(request, response);

        } else {

            dao.register(user, pass);

            response.sendRedirect("login.jsp");
        }
    }
}
