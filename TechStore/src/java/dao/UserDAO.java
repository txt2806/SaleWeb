package dao;

import java.sql.*;
import model.User;

public class UserDAO extends DBContext {

    public User login(String user, String pass) {

        String sql = "SELECT * FROM users WHERE username=? AND password=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void register(String user, String pass) {

        String sql = "INSERT INTO users VALUES(?,?)";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, user);
            st.setString(2, pass);

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkUserExist(String username) {

        String sql = "SELECT * FROM users WHERE username = ?";

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
