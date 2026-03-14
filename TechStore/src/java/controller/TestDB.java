package controller;

import dao.DBContext;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/testdb")
public class TestDB extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DBContext db = new DBContext();

        if(db.connection != null){
            response.getWriter().println("Connected to Database");
        }else{
            response.getWriter().println("Connection Failed");
        }
    }
}