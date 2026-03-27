package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO extends DBContext {

    // Helper: map ResultSet → User
    private User mapUser(ResultSet rs) throws Exception {
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

    public User login(String user, String pass) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.trim());
            st.setString(2, pass);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerVerifiedUser(String user, String pass, String email, String phone) {
        return registerVerifiedUserWithAvatar(user, pass, email, phone, null);
    }

    public boolean registerVerifiedUserWithAvatar(String user, String pass, String email, String phone, String avatar) {
        String sql = "INSERT INTO Users (username, password, email, phone, role, is_verified, avatar) VALUES (?, ?, ?, ?, 0, 1, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.trim());
            st.setString(2, pass);
            st.setString(3, email != null ? email.trim() : null);
            st.setString(4, phone != null ? phone.trim() : null);
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
            st.setString(1, user.trim());
            st.setString(2, pass);
            st.setString(3, email != null ? email.trim() : null);
            st.setString(4, phone != null ? phone.trim() : null);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email.trim());
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void verifyUser(String email) {
        String sql = "UPDATE Users SET is_verified = 1 WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email.trim());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getEmailByUsername(String username) {
        String sql = "SELECT email FROM Users WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username.trim());
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getString("email");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement("SELECT * FROM Users ORDER BY role DESC, id DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapUser(rs));
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

    public boolean deleteUser(int id) {
        try {
            connection.setAutoCommit(false);
            try {
                connection.createStatement().executeUpdate(
                    "ALTER TABLE Orders ALTER COLUMN user_id INT NULL");
            } catch (Exception ignore) {}
            PreparedStatement st1 = connection.prepareStatement("UPDATE Orders SET user_id = NULL WHERE user_id = ?");
            st1.setInt(1, id);
            st1.executeUpdate();
            PreparedStatement st2 = connection.prepareStatement("DELETE FROM Users WHERE id = ? AND role != 1");
            st2.setInt(1, id);
            st2.executeUpdate();
            connection.commit();
            return true;
        } catch (Exception e) {
            try { connection.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (Exception ex) {}
        }
    }

    public User getUserById(int id) {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Users WHERE id = ?");
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- Kiểm tra trùng Email/SĐT ---
    public boolean isEmailExists(String email) {
        return isEmailExists(email, -1);
    }

    public boolean isEmailExists(String email, int excludeUserId) {
        if (email == null || email.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? AND id != ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email.trim());
            st.setInt(2, excludeUserId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isPhoneExists(String phone) {
        return isPhoneExists(phone, -1);
    }

    public boolean isPhoneExists(String phone, int excludeUserId) {
        if (phone == null || phone.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM Users WHERE phone = ? AND id != ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, phone.trim());
            st.setInt(2, excludeUserId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isUsernameExists(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username.trim());
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

