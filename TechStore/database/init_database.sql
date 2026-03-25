USE [master];
GO

IF DB_ID('TechStore') IS NOT NULL
BEGIN
	ALTER DATABASE [TechStore] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [TechStore];
END
GO

CREATE DATABASE [TechStore];
GO

USE [TechStore];
GO

-- 1. Bảng Categories
CREATE TABLE [dbo].[Categories](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[name] [nvarchar](100) NOT NULL,
	[parent_id] [int] DEFAULT 0,
	[created_at] [datetime] DEFAULT GETDATE()
);
GO

-- 2. Bảng Users
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[username] [varchar](50) NOT NULL UNIQUE,
	[password] [varchar](255) NOT NULL,
	[role] [int] DEFAULT 0,
	[email] [varchar](100) NULL,
	[phone] [varchar](20) NULL,
	[is_verified] [int] DEFAULT 0 CHECK ([is_verified] IN (0, 1)),
	[token] [varchar](50) NULL,
	[avatar] [varchar](500) NULL,
	[created_at] [datetime] DEFAULT GETDATE()
);
GO

-- 3. Bảng Products
CREATE TABLE [dbo].[Products](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[name] [nvarchar](200) NOT NULL,
	[price] [decimal](18,2) NOT NULL,
	[description] [nvarchar](max) NULL,
	[image] [varchar](500) NULL,
	[category_id] [int] NULL,
	[is_featured] [bit] DEFAULT 0,
	[is_deleted] [bit] DEFAULT 0 NOT NULL,
	[sold_quantity] [int] DEFAULT 0,
	[created_at] [datetime] DEFAULT GETDATE(),
	[updated_at] [datetime] DEFAULT GETDATE(),
	CONSTRAINT FK_Product_Category FOREIGN KEY ([category_id]) REFERENCES [dbo].[Categories]([id])
);
GO

-- 4. Bảng Orders
CREATE TABLE [dbo].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL DEFAULT GETDATE(),
	[total_amount] [decimal](18,2) NOT NULL,
	[shipping_name] [nvarchar](100) NULL,
	[shipping_phone] [varchar](20) NULL,
	[shipping_address] [nvarchar](500) NULL,
	[status] [varchar](50) NOT NULL DEFAULT 'Pending',
	CONSTRAINT FK_Order_User FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users]([id])
);
GO

-- 5. Bảng OrderDetails
CREATE TABLE [dbo].[OrderDetails](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[price] [decimal](18,2) NOT NULL,
	[quantity] [int] NOT NULL,
	CONSTRAINT FK_OrderDetail_Order FOREIGN KEY ([order_id]) REFERENCES [dbo].[Orders]([id]),
	CONSTRAINT FK_OrderDetail_Product FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products]([id])
);
GO

INSERT INTO [dbo].[Users] ([username], [password], [email], [role], [is_verified]) VALUES ('admin', 'admin', 'admin@techstore.com', 1, 1);
GO
SET IDENTITY_INSERT [dbo].[Categories] ON;

INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (1, N'Laptop', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (2, N'PC Máy Bộ', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (3, N'Bàn phím', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (4, N'Chuột', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (5, N'Màn hình', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (6, N'Linh kiện PC', 0)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (7, N'CPU', 6)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (8, N'RAM', 6)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (9, N'VGA - Card màn hình', 6)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (10, N'Tản nhiệt', 6)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (11, N'Mainboard', 6)
INSERT [dbo].[Categories] ([id], [name], [parent_id]) VALUES (12, N'Ổ cứng', 6)


SET IDENTITY_INSERT [dbo].[Categories] OFF;
SET IDENTITY_INSERT [dbo].[Products] ON;

INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (1, 
N'MacBook Pro 14 M3 Pro 2023', 49990000, N'Apple M3 Pro, 18GB RAM, 512GB SSD', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Macbook+Pro+14', 1, 1)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (2, 
N'ASUS ROG Strix G16 (2024)', 42990000, N'Intel Core i7-13650HX, RTX 4060, 16GB, 512GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ROG+Strix+G16', 1, 1)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (3, 
N'Lenovo Legion 5 Pro 16ARX8', 35990000, N'Ryzen 7 7745HX, RTX 4060, 16GB, 1TB, 240Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Legion+5+Pro', 1, 1)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (4, 
N'Dell XPS 15 9530', 55990000, N'Core i7-13700H, RTX 4050, 16GB, 1TB OLED 3.5K', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Dell+XPS+15', 1, 1)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (5, 
N'Acer Nitro 5 Tiger 2023', 22990000, N'Core i5-12500H, RTX 3050Ti, 8GB, 512GB, 144Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Acer+Nitro+5', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (6, N'MSI 
Katana 15 B13VEK', 27490000, N'Core i7-13620H, RTX 4050, 16GB, 512GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=MSI+Katana+15', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (7, N'HP 
Victus 16 2023', 25990000, N'Ryzen 5 7640HS, RTX 4050, 16GB, 512GB, 144Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=HP+Victus+16', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (8, 
N'MacBook Air 15 M2', 32990000, N'Apple M2, 8GB RAM, 256GB SSD', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Macbook+Air+15', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (9, N'LG 
Gram 14 2023', 28990000, N'Core i7-1360P, 16GB RAM, 512GB SSD, 999g', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=LG+Gram+14', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (10, 
N'ASUS Zenbook 14 OLED', 26990000, N'Core i5-1340P, 16GB RAM, 512GB SSD, 90Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Zenbook+14', 1, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (11, N'PC 
Gaming ROG Strix G10', 25000000, N'Core i5 11400F, GTX 1660 Ti, 8GB, 512GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+ROG+Strix', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (12, N'PC 
MSI MAG Infinite S3', 32000000, N'Core i7 13700F, RTX 4060, 16GB, 1TB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+MSI+MAG', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (13, N'PC 
HP Omen 25L', 38000000, N'Ryzen 7 5800X, RTX 3070, 16GB, 1TB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+HP+Omen', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (14, N'PC 
Dell Alienware Aurora R15', 85000000, N'Core i9 13900KF, RTX 4090 24GB, 32GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Alienware+R15', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (15, N'PC 
Văn Phòng Dell Optiplex', 12500000, N'Core i3 12100, 8GB RAM, 256GB SSD', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+Dell+Optiplex', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (16, N'PC 
Đồ Họa Master Pro', 45000000, N'Core i7 13700K, RTX 4070 Ti, 32GB, 1TB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+Creator', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (17, N'PC 
Gaming Quốc Dân 2024', 15990000, N'Core i5 12400F, RTX 3060 12GB, 16GB, 500GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=PC+Quoc+Dan', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (18, N'PC 
Lenovo Legion Tower 5', 29990000, N'Ryzen 5 7600, RTX 4060 Ti, 16GB, 512GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Legion+Tower+5', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (19, N'PC 
Mini Apple Mac Studio M2', 55000000, N'Apple M2 Max, 32GB RAM, 512GB SSD', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Mac+Studio', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (20, N'PC 
Acer Predator Orion 3000', 34500000, N'Core i7 12700F, RTX 3070, 16GB, 1TB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Acer+Predator', 2, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (21, 
N'Bàn phím cơ Logitech G Pro X TKL', 4500000, N'Không dây Lightspeed, Switch GX Tactile', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Logitech+G+Pro+X', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (22, 
N'Bàn phím cơ Razer BlackWidow V4', 3890000, N'Switch Green Clicky, Đèn Chroma RGB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=BlackWidow+V4', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (23, 
N'Bàn phím cơ Keychron K2 Pro', 2200000, N'Bluetooth 5.1, Hỗ trợ QMK/VIA', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Keychron+K2', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (24, 
N'Bàn phím cơ Akko 3098B', 1890000, N'Switch Akko CS, 3 chế độ kết nối', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Akko+3098B', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (25, 
N'Bàn phím cơ Corsair K70 RGB PRO', 4100000, N'Switch Cherry MX Red, 8000Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Corsair+K70', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (26, 
N'Bàn phím cơ Asus ROG Strix Scope II', 3500000, N'ROG NX Snow Switch, Đệm mút EVA', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ROG+Scope+II', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (27, 
N'Bàn phím cơ DareU EK87', 550000, N'Switch D-Switch, LED Rainbow', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=DareU+EK87', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (28, 
N'Bàn phím Apple Magic Keyboard', 2500000, N'Phím cắt kéo, Kết nối Bluetooth', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Magic+Keyboard', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (29, 
N'Bàn phím cơ Leopold FC750R', 3200000, N'Keycap PBT Double Shot 1.5mm', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Leopold+FC750R', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (30, 
N'Bàn phím giả cơ E-Dra EK501', 250000, N'LED nền, Chống nước nhẹ', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=E-Dra+EK501', 3, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (31, 
N'Chuột Logitech G Pro X Superlight 2', 3590000, N'Cảm biến Hero 2, 32000 DPI, 60g', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=G+Pro+Superlight', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (32, 
N'Chuột Razer DeathAdder V3 Pro', 3790000, N'Cảm biến Focus Pro 30K, 63g', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Razer+DA+V3', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (33, 
N'Chuột Zowie EC2-CW Wireless', 3800000, N'Công thái học eSports, Receiver rời', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Zowie+EC2', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (34, 
N'Chuột Logitech G502 Hero', 950000, N'Cảm biến Hero 25K, Tạ tùy chỉnh', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Logitech+G502', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (35, 
N'Chuột Asus ROG Harpe Ace', 3200000, N'Trọng lượng 54g, AimPoint 36K', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ROG+Harpe+Ace', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (36, 
N'Chuột Corsair Harpoon RGB', 1200000, N'Slipstream 1ms, 10000 DPI', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Corsair+Harpoon', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (37, 
N'Chuột SteelSeries Aerox 3', 2100000, N'Thiết kế tổ ong 66g, IP54', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Aerox+3', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (38, 
N'Chuột Logitech MX Master 3S', 2600000, N'Cảm biến 8000 DPI, Cuộn MagSpeed', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=MX+Master+3S', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (39, 
N'Chuột Fuhlen G90', 350000, N'Nút bấm bất tử Magnet-driven', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Fuhlen+G90', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (40, 
N'Chuột DareU EM901X', 650000, N'Không dây, Kèm Dock sạc LED RGB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=DareU+EM901X', 4, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (41, 
N'Màn hình LG UltraGear 27GR75Q', 7500000, N'27 inch 2K, IPS 165Hz, 1ms', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=LG+27GR75Q', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (42, 
N'Màn hình Asus TUF VG27AQ3A', 6800000, N'27 inch 2K, Fast IPS 180Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Asus+TUF+27', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (43, 
N'Màn hình Samsung Odyssey G5', 6200000, N'27 inch Cong 1000R, 2K VA 165Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Odyssey+G5', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (44, 
N'Màn hình Dell UltraSharp U2724D', 11500000, N'27 inch 2K, IPS Black 120Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Dell+U2724D', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (45, 
N'Màn hình AOC 24G2SP', 3200000, N'24 inch FHD, IPS 165Hz, 1ms', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=AOC+24G2SP', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (46, 
N'Màn hình Gigabyte G24F 2', 3600000, N'24 inch FHD, Super Speed IPS 180Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Gigabyte+G24F', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (47, 
N'Màn hình ViewSonic VX2728J-2K', 5900000, N'27 inch 2K, Fast IPS 165Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ViewSonic+2K', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (48, 
N'Màn hình Zowie XL2546K', 12500000, N'24.5 inch FHD, TN 240Hz, DyAc+', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Zowie+XL2546K', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (49, 
N'Màn hình MSI G274F', 4500000, N'27 inch FHD, Rapid IPS 180Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=MSI+G274F', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (50, 
N'Màn hình HKC MB24V13', 1800000, N'24 inch FHD, IPS 75Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=HKC+24+inch', 5, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (51, 
N'CPU Intel Core i9-14900K', 15990000, N'24 Nhân 32 Luồng, 6.0GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i9+14900K', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (52, 
N'CPU Intel Core i7-14700K', 10990000, N'20 Nhân 28 Luồng, 5.6GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i7+14700K', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (53, 
N'CPU Intel Core i5-13400F', 5500000, N'10 Nhân 16 Luồng, 4.6GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i5+13400F', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (54, 
N'CPU Intel Core i3-12100F', 2200000, N'4 Nhân 8 Luồng, 4.3GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i3+12100F', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (55, 
N'CPU AMD Ryzen 9 7950X', 14500000, N'16 Nhân 32 Luồng, 5.7GHz, Socket AM5', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Ryzen+9+7950X', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (56, 
N'CPU AMD Ryzen 7 7800X3D', 10500000, N'8 Nhân 16 Luồng, 5.0GHz, 3D V-Cache', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Ryzen+7+7800X3D', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (57, 
N'CPU AMD Ryzen 5 7600', 5800000, N'6 Nhân 12 Luồng, 5.1GHz, Socket AM5', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Ryzen+5+7600', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (58, 
N'CPU AMD Ryzen 5 5600X', 3900000, N'6 Nhân 12 Luồng, 4.6GHz, Socket AM4', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Ryzen+5+5600X', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (59, 
N'CPU Intel Core i5-12400F', 3500000, N'6 Nhân 12 Luồng, 4.4GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i5+12400F', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (60, 
N'CPU Intel Core i7-13700K', 9500000, N'16 Nhân 24 Luồng, 5.4GHz, Socket 1700', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Core+i7+13700K', 7, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (61, 
N'RAM Corsair Vengeance RGB 32GB', 3500000, N'2x16GB, DDR5 6000MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Corsair+32GB+D5', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (62, 
N'RAM G.Skill Trident Z5 RGB 32GB', 3800000, N'2x16GB, DDR5 6400MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Trident+Z5+32GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (63, 
N'RAM Kingston Fury Beast 16GB', 1200000, N'2x8GB, DDR4 3200MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Fury+Beast+16GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (64, 
N'RAM Adata XPG Spectrix D41 16GB', 1300000, N'2x8GB, DDR4 3200MHz RGB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=XPG+D41+16GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (65, 
N'RAM Corsair Dominator Platinum 32GB', 4500000, N'2x16GB, DDR5 6200MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Dominator+32GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (66, 
N'RAM TeamGroup T-Force Delta 16GB', 1400000, N'2x8GB, DDR4 3600MHz RGB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=T-Force+16GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (67, 
N'RAM G.Skill Ripjaws V 16GB', 1100000, N'2x8GB, DDR4 3200MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Ripjaws+V+16GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (68, 
N'RAM Lexar Ares RGB 32GB', 3200000, N'2x16GB, DDR5 6000MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Lexar+Ares+32GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (69, 
N'RAM Crucial Pro 32GB', 2800000, N'2x16GB, DDR5 5600MHz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Crucial+Pro+32GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (70, 
N'RAM Kingston Fury Impact 16GB', 1350000, N'1x16GB, DDR4 3200MHz (Laptop)', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Fury+Impact+16GB', 8, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (71, 
N'VGA RTX 4090 24GB ROG Strix', 65000000, N'NVIDIA GeForce RTX 4090, 24GB GDDR6X', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+4090+ROG', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (72, 
N'VGA RTX 4080 Super 16GB AORUS', 32000000, N'NVIDIA GeForce RTX 4080 Super, 16GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+4080+Super', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (73, 
N'VGA RTX 4070 Ti Super 16GB TUF', 25000000, N'NVIDIA GeForce RTX 4070 Ti Super, 16GB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+4070+Ti', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (74, 
N'VGA RTX 4060 Ti 8GB Gaming X', 12500000, N'NVIDIA GeForce RTX 4060 Ti, 8GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+4060+Ti', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (75, 
N'VGA RTX 4060 8GB Ventus', 8500000, N'NVIDIA GeForce RTX 4060, 8GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+4060', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (76, 
N'VGA RTX 3060 12GB Dual', 7500000, N'NVIDIA GeForce RTX 3060, 12GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RTX+3060', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (77, 
N'VGA RX 7900 XTX 24GB Nitro+', 31000000, N'AMD Radeon RX 7900 XTX, 24GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RX+7900+XTX', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (78, 
N'VGA RX 7800 XT 16GB Hellhound', 15500000, N'AMD Radeon RX 7800 XT, 16GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RX+7800+XT', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (79, 
N'VGA RX 7600 8GB Pulse', 7800000, N'AMD Radeon RX 7600, 8GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=RX+7600', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (80, 
N'VGA GTX 1650 4GB OC', 3500000, N'NVIDIA GeForce GTX 1650, 4GB GDDR6', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=GTX+1650', 9, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (81, 
N'Tản nhiệt nước Corsair iCUE H150i', 4500000, N'Tản nhiệt nước AIO 360mm, Màn hình LCD', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Corsair+H150i', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (82, 
N'Tản nhiệt nước NZXT Kraken Elite 360', 7500000, N'Tản nhiệt AIO 360mm, LCD 60Hz', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=NZXT+Kraken', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (83, 
N'Tản nhiệt nước Deepcool LT720', 3200000, N'Tản nhiệt AIO 360mm, Block vô cực', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Deepcool+LT720', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (84, 
N'Tản nhiệt khí Noctua NH-D15', 2800000, N'Tản nhiệt khí tháp đôi siêu êm', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Noctua+NH-D15', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (85, 
N'Tản nhiệt Thermalright Peerless Assassin 120', 1100000, N'Tản nhiệt khí tháp đôi vô địch tầm giá', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Assassin+120', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (86, 
N'Tản nhiệt Cooler Master ML240L', 1800000, N'Tản nhiệt nước AIO 240mm RGB', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=CM+ML240L', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (87, 
N'Tản nhiệt khí ID-Cooling SE-224-XTS', 550000, N'Tản nhiệt khí quốc dân, 4 ống đồng', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ID-Cooling', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (88, 
N'Tản nhiệt khí Deepcool AK400', 650000, N'Tản nhiệt khí 4 ống đồng, Thiết kế ma trận', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Deepcool+AK400', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (89, 
N'Tản nhiệt Asus ROG Ryujin III 360', 8500000, N'AIO 360mm cao cấp, Màn hình Anime Matrix', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=ROG+Ryujin+III', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (90, 
N'Tản nhiệt Lian Li Galahad II 360', 6200000, N'Tản nhiệt AIO 360mm, Bơm Asetek Gen 8', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Lian+Li+Galahad', 10, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (91, 
N'Mainboard ASUS ROG Maximus Z790 Hero', 16500000, N'Socket 1700, DDR5, Wi-Fi 6E', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Z790+Hero', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (92, 
N'Mainboard Gigabyte Z790 AORUS ELITE', 7800000, N'Socket 1700, DDR5, PCIe 5.0', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Z790+AORUS', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (93, 
N'Mainboard MSI MAG B760M MORTAR', 4500000, N'Socket 1700, mATX, DDR5', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=B760M+MORTAR', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (94, 
N'Mainboard ASRock B760M Pro RS', 3200000, N'Socket 1700, DDR4, Trắng ngọc trai', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=B760M+Pro+RS', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (95, 
N'Mainboard MSI MEG X670E GODLIKE', 25000000, N'Socket AM5, E-ATX, Siêu mainboard', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=X670E+GODLIKE', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (96, 
N'Mainboard ASUS ROG Strix B650E-F', 7200000, N'Socket AM5, DDR5, PCIe 5.0', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=B650E-F+Strix', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (97, 
N'Mainboard Gigabyte B650 AORUS ELITE', 5800000, N'Socket AM5, ATX, Wi-Fi 6E', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=B650+AORUS', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (98, 
N'Mainboard ASRock B650M Pro RS', 3500000, N'Socket AM5, mATX, DDR5', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=B650M+Pro+RS', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (99, 
N'Mainboard ASUS TUF H770-PRO WIFI', 5500000, N'Socket 1700, ATX, Siêu bền', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=TUF+H770', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (100, 
N'Mainboard MSI PRO H610M-E', 1800000, N'Socket 1700, DDR4, Main văn phòng', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=H610M-E', 11, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (101, N'Ổ 
cứng SSD Samsung 990 Pro 1TB', 3200000, N'PCIe Gen 4.0 x4, Đọc 7450MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Samsung+990+Pro', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (102, N'Ổ 
cứng SSD WD Black SN850X 1TB', 2800000, N'PCIe Gen 4.0 x4, Đọc 7300MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=WD+SN850X', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (103, N'Ổ 
cứng SSD Kingston KC3000 1TB', 2400000, N'PCIe Gen 4.0, Đọc 7000MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Kingston+KC3000', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (104, N'Ổ 
cứng SSD Crucial P3 Plus 1TB', 1800000, N'PCIe Gen 4.0, Đọc 5000MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Crucial+P3+', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (105, N'Ổ 
cứng SSD Samsung 980 500GB', 1200000, N'PCIe Gen 3.0, Đọc 3100MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Samsung+980', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (106, N'Ổ 
cứng SSD WD Blue SN570 500GB', 1100000, N'PCIe Gen 3.0, Đọc 3500MB/s', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=WD+SN570', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (107, N'Ổ 
cứng SSD Kingston NV2 250GB', 650000, N'PCIe Gen 4.0, Khởi động Win siêu nhanh', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Kingston+NV2', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (108, N'Ổ 
cứng HDD WD Blue 2TB', 1450000, N'7200rpm, SATA III 6GB/s, 256MB Cache', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=WD+Blue+2TB', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (109, N'Ổ 
cứng HDD Seagate Barracuda 1TB', 1050000, N'7200rpm, Lưu trữ dữ liệu', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=Seagate+1TB', 12, 0)
INSERT [dbo].[Products] ([id], [name], [price], [description], [image], [category_id], [is_featured]) VALUES (110, N'Ổ 
cứng SSD Samsung 870 EVO 500GB', 1350000, N'2.5 inch SATA III, Nâng cấp laptop cũ', 
N'https://placehold.co/600x600/f8f9fa/d70018?text=870+EVO', 12, 0)


