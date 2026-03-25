USE [TechStore]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL DEFAULT GETDATE(),
	[total_amount] [float] NOT NULL,
	[status] [varchar](50) NOT NULL DEFAULT 'Completed'
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDetails](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[order_id] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[Orders]([id]),
	[product_id] [int] NOT NULL,
	[price] [float] NOT NULL,
	[quantity] [int] NOT NULL
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND name = 'is_deleted')
BEGIN
ALTER TABLE [dbo].[Products] ADD [is_deleted] [bit] NOT NULL DEFAULT 0;
END
GO
