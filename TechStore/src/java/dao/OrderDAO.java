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
            
            // 1. Insert Order with status Pending
            String sqlOrder = "INSERT INTO Orders (user_id, total_amount, status, shipping_name, shipping_address, shipping_phone) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, "Pending");
            psOrder.setString(4, order.getShippingName());
            psOrder.setString(5, order.getShippingAddress());
            psOrder.setString(6, order.getShippingPhone());
            psOrder.executeUpdate();
            
            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
                
                // 2. Insert OrderDetails
                String sqlDetail = "INSERT INTO OrderDetails (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
                
                for (OrderDetail d : details) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, d.getProductId());
                    psDetail.setDouble(3, d.getPrice());
                    psDetail.setInt(4, d.getQuantity());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
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
                    rs.getString("shipping_name"),
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
                if (d.getProductName() == null) d.setProductName("San pham da bi xoa");
                d.setProductImage(rs.getString("p_image"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateOrderStatus(int orderId, String newStatus) {
        try {
            // If changing to Completed, update sold_quantity for each product
            if ("Completed".equals(newStatus)) {
                List<OrderDetail> details = getOrderDetails(orderId);
                String sqlUpdate = "UPDATE Products SET sold_quantity = ISNULL(sold_quantity, 0) + ? WHERE id = ?";
                PreparedStatement psUpdate = connection.prepareStatement(sqlUpdate);
                for (OrderDetail d : details) {
                    psUpdate.setInt(1, d.getQuantity());
                    psUpdate.setInt(2, d.getProductId());
                    psUpdate.addBatch();
                }
                psUpdate.executeBatch();
            }

            String sql = "UPDATE Orders SET status = ? WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getOrderStatus(int orderId) {
        try {
            String sql = "SELECT status FROM Orders WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("status");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
