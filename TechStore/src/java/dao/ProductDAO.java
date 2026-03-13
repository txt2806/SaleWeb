package dao;

import java.sql.*;
import java.util.*;
import model.Product;

public class ProductDAO extends DBContext {

    public List<Product> getAllProducts(){

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products";

        try{

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while(rs.next()){

                Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("description")
                );

                list.add(p);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}