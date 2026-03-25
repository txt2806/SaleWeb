import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBMigration {
    public static void main(String[] args) {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=TechStore;encrypt=false";
            String user = "sa";
            String pass = "123456";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            System.out.println("Connected to Database");

            String createOrders = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U')) " +
                    "BEGIN CREATE TABLE [dbo].[Orders]( " +
                    "[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY, " +
                    "[user_id] [int] NOT NULL, " +
                    "[order_date] [datetime] NOT NULL DEFAULT GETDATE(), " +
                    "[total_amount] [float] NOT NULL, " +
                    "[status] [varchar](50) NOT NULL DEFAULT 'Completed' " +
                    "); END";

            String createOrderDetails = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetails]') AND type in (N'U')) " +
                    "BEGIN CREATE TABLE [dbo].[OrderDetails]( " +
                    "[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY, " +
                    "[order_id] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[Orders]([id]), " +
                    "[product_id] [int] NOT NULL, " +
                    "[price] [float] NOT NULL, " +
                    "[quantity] [int] NOT NULL " +
                    "); END";

            String addIsDeleted = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND name = 'is_deleted') " +
                    "BEGIN ALTER TABLE [dbo].[Products] ADD [is_deleted] [bit] NOT NULL DEFAULT 0; END";

            stmt.execute(createOrders);
            System.out.println("Orders table checked/created.");
            stmt.execute(createOrderDetails);
            System.out.println("OrderDetails table checked/created.");
            stmt.execute(addIsDeleted);
            System.out.println("is_deleted column checked/added to Products.");

            stmt.close();
            conn.close();
            System.out.println("Migration completed successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
