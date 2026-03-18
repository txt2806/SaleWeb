package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int pId = 0;
                try {
                    pId = rs.getInt("parent_id");
                } catch (Exception e) {
                }

                list.add(new Category(rs.getInt("id"), rs.getString("name"), pId));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
