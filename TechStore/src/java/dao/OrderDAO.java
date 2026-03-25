package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class OrderDAO extends DBContext {

    public int createOrder(Order order, List<OrderDetail> details) {
        int orderId = 0;
        try {
            connection.setAutoCommit(false);
            
            // 1. Insert Order
            String sqlOrder = "INSERT INTO Orders (user_id, total_amount, status, shipping_address, shipping_phone) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, "Completed");
            psOrder.setString(4, order.getShippingAddress());
            psOrder.setString(5, order.getShippingPhone());
            psOrder.executeUpdate();
            
            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
                
                // 2. Insert OrderDetails
                String sqlDetail = "INSERT INTO OrderDetails (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
                
                // 3. Update Product sold_quantity
                String sqlUpdateSold = "UPDATE Products SET sold_quantity = ISNULL(sold_quantity, 0) + ? WHERE id = ?";
                PreparedStatement psUpdateSold = connection.prepareStatement(sqlUpdateSold);
                
                for (OrderDetail d : details) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, d.getProductId());
                    psDetail.setDouble(3, d.getPrice());
                    psDetail.setInt(4, d.getQuantity());
                    psDetail.addBatch();
                    
                    psUpdateSold.setInt(1, d.getQuantity());
                    psUpdateSold.setInt(2, d.getProductId());
                    psUpdateSold.addBatch();
                }
                psDetail.executeBatch();
                psUpdateSold.executeBatch();
            }
            connection.commit();
            connection.setAutoCommit(true);
        } catch (Exception e) {
            try { connection.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
        }
        return orderId;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement("SELECT * FROM Orders ORDER BY order_date DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getTimestamp("order_date"),
                    rs.getDouble("total_amount"),
                    rs.getString("status"),
                    rs.getString("shipping_address"),
                    rs.getString("shipping_phone")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        try {
            String sql = "SELECT d.*, p.name as p_name, p.image as p_image FROM OrderDetails d "
                       + "LEFT JOIN Products p ON d.product_id = p.id WHERE d.order_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail d = new OrderDetail(
                    rs.getInt("id"),
                    rs.getInt("order_id"),
                    rs.getInt("product_id"),
                    rs.getDouble("price"),
                    rs.getInt("quantity")
                );
                d.setProductName(rs.getString("p_name"));
                if (d.getProductName() == null) d.setProductName("Sản phẩm đã bị xóa");
                d.setProductImage(rs.getString("p_image"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
