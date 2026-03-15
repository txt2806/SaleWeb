package dao;

import java.sql.*;
import model.User;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username=? AND password=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role") // Lấy thêm cột role
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void register(String username, String password) {
        String sql = "INSERT INTO Users(username, password, role) VALUES(?, ?, 0)"; // Mặc định role = 0 (User)
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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
