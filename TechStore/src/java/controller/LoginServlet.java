package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();

        User u = dao.login(user, pass);

        if (u == null) {

            request.setAttribute("error", "Account or password is incorrect");

            request.getRequestDispatcher("login.jsp").forward(request, response);

        } else {

            request.getSession().setAttribute("user", u);

            response.sendRedirect("index.jsp");
        }
    }
}
