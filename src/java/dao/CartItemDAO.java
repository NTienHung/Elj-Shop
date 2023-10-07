package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class CartItemDAO extends jdbc.DBConnect{
    public int deleteByCartId(int cartId) {
        int affectedRows = 0;
        String sql = "DELETE FROM [dbo].[CartItem]\n"
                + " WHERE cartId = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, cartId);
            affectedRows = pre.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return affectedRows;
    }
}
