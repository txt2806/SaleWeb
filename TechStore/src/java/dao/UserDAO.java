package dao;

import java.sql.*;
import model.User;

public class UserDAO extends DBContext {

    // LOGIN
    public User login(String username, String password) {

        String sql = "SELECT * FROM Users WHERE username=? AND password=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, username);
            st.setString(2, password);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                User u = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password")
                );

                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // REGISTER
    public void register(String username, String password) {

        String sql = "INSERT INTO Users(username,password) VALUES(?,?)";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, username);
            st.setString(2, password);

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // CHECK USER EXIST
    public boolean checkUserExist(String username) {

        String sql = "SELECT * FROM Users WHERE username=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, username);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}
