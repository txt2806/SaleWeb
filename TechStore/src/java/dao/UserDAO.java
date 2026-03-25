package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO extends DBContext {

    public User login(String user, String pass) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                u.setIsVerified(rs.getInt("is_verified"));
                u.setToken(rs.getString("token"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerWithToken(String user, String pass, String email, String token) {
        String sql = "INSERT INTO Users (username, password, email, role, is_verified, token) VALUES (?, ?, ?, 0, 0, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            st.setString(3, email);
            st.setString(4, token);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean registerVerifiedUser(String user, String pass, String email, String phone) {
        return registerVerifiedUserWithAvatar(user, pass, email, phone, null);
    }

    public boolean registerVerifiedUserWithAvatar(String user, String pass, String email, String phone, String avatar) {
        String sql = "INSERT INTO Users (username, password, email, phone, role, is_verified, avatar) VALUES (?, ?, ?, ?, 0, 1, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            st.setString(3, email);
            st.setString(4, phone);
            st.setString(5, avatar);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registerUnverifiedUser(String user, String pass, String email, String phone) {
        String sql = "INSERT INTO Users (username, password, email, phone, role, is_verified) VALUES (?, ?, ?, ?, 0, 0)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user);
            st.setString(2, pass);
            st.setString(3, email);
            st.setString(4, phone);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateToken(String email, String token) {
        String sql = "UPDATE Users SET token = ? WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            st.setString(2, email);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setIsVerified(rs.getInt("is_verified"));
                u.setToken(rs.getString("token"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void verifyUser(String email) {
        String sql = "UPDATE Users SET is_verified = 1, token = NULL WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement("SELECT * FROM Users ORDER BY role DESC, id DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                u.setIsVerified(rs.getInt("is_verified"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPassword);
            st.setInt(2, userId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getUserById(int id) {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Users WHERE id = ?");
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                u.setIsVerified(rs.getInt("is_verified"));
                u.setPhone(rs.getString("phone"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
