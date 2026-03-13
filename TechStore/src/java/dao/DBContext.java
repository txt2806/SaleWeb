package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    protected Connection connection;

    public DBContext() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=TechStore";
            String user = "sa";
            String pass = "123456";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}