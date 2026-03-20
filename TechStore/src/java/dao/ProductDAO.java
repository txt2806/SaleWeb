package dao;

import java.sql.*;
import java.util.*;
import model.Product;

public class ProductDAO extends DBContext {

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        int soldQty = 0;
        try {
            soldQty = rs.getInt("sold_quantity");
        } catch (Exception e) {
        }

        return new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("description"),
                rs.getString("image"),
                rs.getInt("category_id"),
                rs.getBoolean("is_featured"),
                soldQty
        );
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getFeaturedProducts() {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE is_featured = 1");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE category_id = ?");
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> search(String keyword) {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE name LIKE ?");
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE id=?");
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addProduct(Product p) {
        String sql = "INSERT INTO Products(name, price, description, image, category_id, is_featured, sold_quantity) VALUES(?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setDouble(2, p.getPrice());
            st.setString(3, p.getDescription());
            st.setString(4, p.getImage());
            st.setInt(5, p.getCategoryId());
            st.setBoolean(6, p.isFeatured());
            st.setInt(7, p.getSoldQuantity());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateProduct(Product p) {
        String sql = "UPDATE Products SET name=?, price=?, description=?, image=?, category_id=?, is_featured=? WHERE id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setDouble(2, p.getPrice());
            st.setString(3, p.getDescription());
            st.setString(4, p.getImage());
            st.setInt(5, p.getCategoryId());
            st.setBoolean(6, p.isFeatured());
            st.setInt(7, p.getId());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM Products WHERE id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void toggleFeatured(int id) {
        String sql = "UPDATE Products SET is_featured = CASE WHEN is_featured = 1 THEN 0 ELSE 1 END WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Product> getFilteredProducts(String keyword, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE 1=1");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }
        
        if ("price_asc".equals(sortBy)) {
            sql.append(" ORDER BY price ASC");
        } else if ("price_desc".equals(sortBy)) {
            sql.append(" ORDER BY price DESC");
        } else if ("best_selling".equals(sortBy)) {
            // sql.append(" ORDER BY sold_quantity DESC"); // TODO: Bỏ comment khi bạn đã tạo cột sold_quantity trong DB
            sql.append(" ORDER BY id DESC");
        } else if ("least_selling".equals(sortBy)) {
            // sql.append(" ORDER BY sold_quantity ASC"); // TODO: Bỏ comment khi bạn đã tạo cột sold_quantity trong DB
            sql.append(" ORDER BY id ASC");
        } else {
            sql.append(" ORDER BY id DESC");
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + keyword + "%");
            }
            if (categoryId != null && categoryId > 0) {
                st.setInt(paramIndex++, categoryId);
            }
            if (minPrice != null) {
                st.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                st.setDouble(paramIndex++, maxPrice);
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
