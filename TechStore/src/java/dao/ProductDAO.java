package dao;

import java.sql.*;
import java.util.*;
import model.Product;

public class ProductDAO extends DBContext {

    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM Products";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("description"),
                        rs.getString("image")
                );

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Product> search(String keyword) {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM Products WHERE name LIKE ?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, "%" + keyword + "%");

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("description"),
                        rs.getString("image")
                );

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Product getProductById(int id) {

        String sql = "SELECT * FROM Products WHERE id=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                return new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("description"),
                        rs.getString("image")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}