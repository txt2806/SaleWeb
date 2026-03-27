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
        int stockVal = 0;
        try {
            stockVal = rs.getInt("stock");
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
                rs.getBoolean("is_deleted"),
                soldQty,
                stockVal,
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at")
        );
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE is_deleted = 0 ORDER BY id DESC");
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
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE is_featured = 1 AND is_deleted = 0 ORDER BY id DESC");
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
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE category_id = ? AND is_deleted = 0 ORDER BY id DESC");
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
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE name LIKE ? AND is_deleted = 0 ORDER BY id DESC");
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

    public List<Product> searchSuggestions(String keyword, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(
                "SELECT TOP (?) * FROM Products WHERE name LIKE ? AND is_deleted = 0 ORDER BY sold_quantity DESC"
            );
            st.setInt(1, limit);
            st.setString(2, "%" + keyword + "%");
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
        String sql = "UPDATE Products SET is_deleted = 1 WHERE id=?";
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

    public void updateStock(int id, int stock) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE Products SET stock = ? WHERE id = ?");
            st.setInt(1, stock);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateFeaturedBatch(String[] featuredIds) {
        try {
            // Bỏ featured tất cả
            connection.createStatement().executeUpdate("UPDATE Products SET is_featured = 0");
            // Đánh dấu featured cho các ID được chọn
            if (featuredIds != null) {
                for (String sid : featuredIds) {
                    PreparedStatement st = connection.prepareStatement("UPDATE Products SET is_featured = 1 WHERE id = ?");
                    st.setInt(1, Integer.parseInt(sid));
                    st.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Product> getFilteredProducts(String keyword, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) {
        return getFilteredProducts(keyword, categoryId, minPrice, maxPrice, sortBy, 1, 100);
    }
    
    public int getTotalFilteredProducts(String keyword, Integer categoryId, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Products WHERE is_deleted = 0");
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
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getFilteredProducts(String keyword, Integer categoryId, Double minPrice, Double maxPrice, String sortBy, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE is_deleted = 0");
        
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
            sql.append(" ORDER BY sold_quantity DESC");
        } else if ("least_selling".equals(sortBy)) {
            sql.append(" ORDER BY sold_quantity ASC");
        } else {
            sql.append(" ORDER BY id DESC");
        }

        try {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
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
            
            st.setInt(paramIndex++, (page - 1) * pageSize);
            st.setInt(paramIndex++, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int getTotalProductsCount() {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT COUNT(*) FROM Products WHERE is_deleted = 0");
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM Products WHERE is_deleted = 0 ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            st.setInt(1, (page - 1) * pageSize);
            st.setInt(2, pageSize);
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
