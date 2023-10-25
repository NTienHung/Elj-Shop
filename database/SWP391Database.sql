use master
go

ALTER DATABASE OnlineShop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
go

drop database if exists OnlineShop 
go

create database OnlineShop
go

use OnlineShop
go

CREATE TABLE [User] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [role] varchar(20) NOT NULL,
  [firstName] nvarchar(50),
  [lastName] nvarchar(50),
  [dateOfBirth] date,
  [street] varchar(50),
  [city] varchar(30),
  [province] varchar(30),
  [country] varchar(30),
  [phone] varchar(15),
  [email] varchar(50),
  [password] varchar(65),
  active bit
)
GO

CREATE TABLE [Provider] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [companyName] varchar(20) NOT NULL,
  [image] nvarchar(max),
  active bit
)
GO

CREATE TABLE [Employee] (
  [id] int PRIMARY KEY NOT NULL,
  [salary] int,
  hireDate date,
  leaveDate date
)
GO

CREATE TABLE [Customer] (
  [id] int PRIMARY KEY NOT NULL,
  [balance] float
)
GO

CREATE TABLE [Product] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [categoryId] int NOT NULL,
  [providerId] int,
  [name] varchar(200),
  [description] varchar(4000),
  [price] float NOT NULL,
  [discount] float DEFAULT (0),
  [quantity] int NOT NULL DEFAULT (0),
  [image] nvarchar(max) NULL ,
  active bit
)
GO

CREATE TABLE [Category] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [name] varchar(20) NOT NULL,
  [image] nvarchar(max),
  active bit
)
GO

CREATE TABLE [Order] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [customerId] int,
  [voucherId] int,
  [receiver] nvarchar(50),
  [shipStreet] varchar(50),
  [shipCity] varchar(30),
  [shipProvince] varchar(30),
  [shipCountry] varchar(30),
  [shipEmail] varchar(50),
  [shipPhone] varchar(15),
  [status] nvarchar(255) NOT NULL,
  [createdTime] datetime,
  [totalPrice] float NOT NULL,
  active bit
)
GO

CREATE TABLE [OrderDetails] (
  [productId] int,
  [orderId] int NOT NULL,
  [price] float NOT NULL,
  [quantity] int NOT NULL DEFAULT (1),
  PRIMARY KEY(productId,orderId)
)
GO

CREATE TABLE [Cart] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [customerId] int NOT NULL
)
GO

CREATE TABLE [CartItem] (
  [productId] int,
  [cartId] int NOT NULL,
  [price] float NOT NULL,
  [quantity] int NOT NULL DEFAULT (1),
  PRIMARY KEY(productId,cartId)
)
GO

CREATE TABLE [ImportOrder] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [providerId] int,
  [managerId] int NOT NULL,
  [status] nvarchar(255) NOT NULL,
  [createdTime] datetime,
  active bit
)
GO

CREATE TABLE [ImportOrderDetails] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [importOrderId] int NOT NULL,
  [productInfomration] varchar(200),
  [price] float NOT NULL,
  [quantity] int NOT NULL DEFAULT (1)
)
GO

CREATE TABLE [Voucher] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [code] nvarchar(50) NOT NULL,
  [startDate] datetime,
  [endDate] datetime,
  [value] int,
  active bit
)
GO

CREATE TABLE [Feedback] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  customerId int,
  productId int,
  sellerId int,
  content nvarchar(1000),
  reply nvarchar(1000),
  feedbackDate date,
  replyDate date,
  checked bit 
)
GO

CREATE TABLE [Report] (
  [id] int PRIMARY KEY NOT NULL IDENTITY(1, 1),
  storageStaffId int,
  managerId int,
  title varchar(100),
  content varchar(1000),
  writeDate datetime,
  readStatus bit
)
GO

ALTER TABLE [Employee] ADD FOREIGN KEY ([id]) REFERENCES [User] ([id])
GO

ALTER TABLE [Customer] ADD FOREIGN KEY ([id]) REFERENCES [User] ([id])
GO

ALTER TABLE [Product] ADD FOREIGN KEY ([categoryId]) REFERENCES [Category] ([id])
GO

ALTER TABLE [Product] ADD FOREIGN KEY ([providerId]) REFERENCES [Provider] ([id])
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([customerId]) REFERENCES [Customer] ([id]) ON DELETE SET NULL;
GO

ALTER TABLE [Order] ALTER COLUMN [customerId] int NULL;
GO

ALTER TABLE [Order] ADD FOREIGN KEY ([voucherId]) REFERENCES [Voucher] ([id])
GO

ALTER TABLE [OrderDetails] ADD FOREIGN KEY ([productId]) REFERENCES [Product] ([id])
GO

ALTER TABLE [OrderDetails] ADD FOREIGN KEY ([orderId]) REFERENCES [Order] ([id])
GO

ALTER TABLE [Cart] ADD FOREIGN KEY ([customerId]) REFERENCES [Customer] ([id])
GO

ALTER TABLE [CartItem] ADD FOREIGN KEY ([productId]) REFERENCES [Product] ([id])
GO

ALTER TABLE [CartItem] ADD FOREIGN KEY ([cartId]) REFERENCES [Cart] ([id])
GO

ALTER TABLE [ImportOrder] ADD FOREIGN KEY ([providerId]) REFERENCES [Provider] ([id])
GO

ALTER TABLE [ImportOrder] ADD FOREIGN KEY ([managerId]) REFERENCES [Employee] ([id])
GO

ALTER TABLE [ImportOrderDetails] ADD FOREIGN KEY ([importOrderId]) REFERENCES [ImportOrder] ([id])
GO

ALTER TABLE Feedback ADD FOREIGN KEY ([productId]) REFERENCES [Product] ([id])
GO

ALTER TABLE Feedback ADD FOREIGN KEY (customerId) REFERENCES [Customer] ([id])
GO

ALTER TABLE [Report] ADD FOREIGN KEY ([storageStaffId]) REFERENCES [Employee] ([id])
GO

ALTER TABLE [Report] ADD FOREIGN KEY ([managerId]) REFERENCES [Employee] ([id])
GO

INSERT [User] ([role],[lastName],[firstName],[dateOfBirth],[street],[province],[city],[country],[phone],[email],[password],[active])
VALUES ('Admin', 'Nguyen Ngoc Tuan', 'Huy', '2003-08-20', 'Tran Hung Dao', 'Ha Noi', 'Ha Dong', 'Viet Nam', '0808123546', 'huynnthe176346@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Nguyen Bao', 'Ngoc', '2004-1-23', 'Trang Hat', 'Ho Chi Minh', 'Quan 1', 'Viet Nam', '0863846324', 'longndhe176282@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Seller', 'Phan Van', 'Khai', '1999-06-17', 'Nguyen Trai','Ha Noi', 'Dong Da', 'Viet Nam', '0823745343', 'khaipvhe175487@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Nguyen Tien', 'Dat', '1995-12-11', 'Quan Trung', 'Ho Chi Minh', 'Quan 3', 'Viet Nam', '0896787365', 'datbiettuot@gmail.com', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Manager', 'Nguyen Tien', 'Hung', '1999-06-29', 'Ly Cong Uan','Ha Noi', 'Nam Tu Loem', 'Viet Nam', '0823745343', 'hungnthe176686@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Nguyen Duc', 'Tai', '1989-2-21', 'Nguyen Hue', 'Can Tho', 'Lac Thuy', 'Viet Nam', '0853673278', 'tailoc@gmail.com', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Nguyen Ba', 'Khanh', '2006-4-4', 'Ton Quyen', 'Nha Trang', 'Tu Hai', 'Viet Nam', '0823846368', 'khanh456@gmail.com', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Pham Truong', 'Giang', '1999-8-11', 'NguyenTrai', 'Hoa Binh', 'Da Hop', 'Viet Nam', '0895736482', 'gianggiang@gmail.com', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Customer', 'Nguyen Tuan', 'Anh', '1997-5-24', 'Xom Che', 'Yen Bai', 'Xuyen Son', 'Viet Nam', '0845783629', 'anhtuan@gmail.com', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Storage Staff', 'Le Dang', 'Huy', '2003-6-4', 'Hung Dao Vuong', 'Thai Nguyen', 'Son Ky', 'Viet Nam', '0834672984', 'huyldhe1762758@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Marketing Staff', 'Dinh Thu', 'Ngan', '2003-9-12', 'Tran Quoc Tuan', 'Hung Yen', 'Dai Quan', 'Viet Nam', '0823945218', 'ngandthe176603@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1),
	('Seller', 'Pham Hoang', 'Nam', '2003-1-1', 'Tran Hung Dao', 'Hai Phong', 'Ky Xa', 'Viet Nam', '0839984672', 'namphhe171209@fpt.edu.vn', '0D6EA9876438BFF527C078E2E3EA9CECBC444BF37B182656197414C5AFF1E90C', 1)

INSERT [Provider] ([companyName], [image],[active]) 
VALUES ('Adidas', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Adidas_logo.png/800px-Adidas_logo.png', 1),
	('Nike', 'https://static.nike.com/a/images/f_jpg,q_auto:eco/61b4738b-e1e1-4786-8f6c-26aa0008e80b/swoosh-logo-black.png', 1),
	('Puma', 'https://1000logos.net/wp-content/uploads/2017/05/PUMA-logo.jpg', 1)

INSERT [Employee] ([id],[salary]) 
VALUES (1, 8000),
	(3, 2000),
	(5, 1800),
	(10, 2200),
	(11, 2100),
	(12, 1900)

INSERT [Customer] ([id],[balance]) 
VALUES (2, 17500),
	(4, 400),
	(6, 1500),
	(7, 8000),
	(8, 4189),
	(9, 23015)

INSERT [Category] ([name], [image],[active]) VALUES ('Sport', 'https://hips.hearstapps.com/hmg-prod/images/hoka-zinal-13085-1643565794.jpg?crop=1.00xw:0.752xh;0,0.115xh&resize=1200:*', 1)
INSERT [Category] ([name], [image],[active]) VALUES ('Business', 'https://assets.adidas.com/images/w_600,f_auto,q_auto/877f87fbcbf34e299720aef600eff064_9366/ADIZERO_SL_Black_HQ1349_01_standard.jpg', 1)
INSERT [Category] ([name], [image],[active]) VALUES ('Vacation', 'https://runkeeper.com/cms/wp-content/uploads/sites/4/2021/12/ASICS_Color-Injection-Pack_Highlight_0253-scaled.jpg', 1)

INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (1, 1, 'Adidas Gazelle Shoes', 'Best Adidas shoes in 2023', 180, 50,'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1658850055-Gazelle_Shoes_Black_BB5476_01_standard.jpg?crop=1xw:1xh;center,top&resize=980:*', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (2, 1, 'Adidas Ultraboost Light Running Shoes', 'Hottest Adidas shoes in May', 220, 72,'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1658850055-Gazelle_Shoes_Black_BB5476_01_standard.jpg?crop=1xw:1xh;center,top&resize=980:*', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (3, 1, 'Adidas x Gucci ZX8000 Sneakers', 'Most comfortable Adidas shoes in winter', 280, 60, 'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1682372665-screenshot-2023-04-24-at-5-44-12-pm-6446f830b1d7d.png?crop=0.9942196531791907xw:1xh;center,top&resize=980:*', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (1, 1, 'Adidas 4DFWD 2 Running Shoes', 'Best Adidas shoes for runner', 199, 58,'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1682372758-4DFWD_2_Running_Shoes_Black_GX9249_01_standard.jpg?crop=1xw:1xh;center,top&resize=980:*', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (2, 2, 'Nike Roshe', 'Best Nike shoes of all time', 350, 90,'https://img.buzzfeed.com/buzzfeed-static/complex/images/Y19jcm9wLGhfMTIyMSx3XzIwMDAseF8wLHlfNDk2/rs33wp3ivhzf3tc89gim/50-nike-roshe-run.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (3, 2, 'Nike Air Zoom Huarache 2K4', 'Hottest Nike shoes for student', 100, 76,'https://img.buzzfeed.com/buzzfeed-static/complex/images/Y19jcm9wLGhfMTI2MCx3XzIwMDAseF8wLHlfNDA1/cunvkzaul1iixnfgys6b/49-nike-air-huarache-2k4.jpg?downsize=700:*&output-format=auto&output-quality=auto', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (1, 2, 'Nike Waffle Racer', 'Nike shoes for summer trip', 320, 39,'https://img.buzzfeed.com/buzzfeed-static/complex/images/Y19jcm9wLGhfMTA4Myx3XzIwMDAseF8wLHlfNjIx/sffqh7d1ocatnxutmjpr/48-nike-waffle-racer.jpg?downsize=700:*&output-format=auto&output-quality=auto', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (2, 2, 'Nike Air Zoom Generation', 'Best option for your trip to America', 333, 70,'https://img.buzzfeed.com/buzzfeed-static/complex/images/Y19jcm9wLGhfMTE1Nix3XzIwMDAseF8wLHlfNDkz/qnhnp2rxiasmqvyhuiti/47-nike-air-zoom-generation.jpg?downsize=700:*&output-format=auto&output-quality=auto', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (3, 3, 'Puma Slipstream', 'Best Puma shoes', 520, 145,'https://cdn.runrepeat.com/i/puma/39568/puma-mens-slipstream-shoes-size-10-5-m-us-color-white-black-white-black-fb22-900.jpg', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (1, 3, 'PUMA RS-X', 'Looking for a good running shoes? This shoes are ', 160, 30,'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1658850055-Gazelle_Shoes_Black_BB5476_01_standard.jpg?crop=1xw:1xh;center,top&resize=980:*', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (2, 3, 'PUMA Future Rider', 'The shoes of future', 420, 70,'https://cdn.runrepeat.com/i/puma/35115/puma-men-s-future-rider-sneaker-white-black-11-puma-white-puma-black-8f1f-900.jpg', 1)
INSERT [Product] ([categoryId], [providerId], [name], [description], [price], [quantity], [image],[active]) VALUES (3, 3, 'PUMA Clasico Trainers', 'Puma shoes for your tranning', 240, 55,'https://cdn.runrepeat.com/i/puma/37788/puma-men-s-clasico-sneaker-white-white-gray-violet-7-5-puma-white-puma-white-gray-violet-f923-900.jpg', 1)

INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (2, 'Nguyen Van Thai', 'Tran Hung Dao', 'Hoa Binh', 'Hoa Binh', 'Viet Nam', 'thaihb@gmail.com', '0847293709', 'Shipping', '2022-12-23 10:34:23', 252, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (4, 'Nguyen Thi Huong', 'Le Thai To', 'Thai Nguyen', 'Thai Nguyen', 'Viet Nam', 'huonghuong@gmail.com', '0823654893', 'Shipping', '2023-05-12 14:45:42', 660, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (4, 'Pham Hoang Dang', 'Le Thai Tong', 'Can Tho', 'Can Tho', 'Viet Nam', 'dangph@gmail.com', '0823123167', 'Shipping', '2023-06-14 18:20:20', 720, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (6, 'Nguyen Dang Hoang', 'Tran Nhan Tong', 'Hai Ba Trung', 'Ha Noi', 'Viet Nam', 'hoangnd@gmail.com', '0856345982', 'Shipping', '2023-01-30 15:05:01', 1284, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (6, 'Dang Thai Duong', 'Le Quy Don', 'Yen Bai', 'Yen Bai', 'Viet Nam', 'duongdt@gmail.com', '0823900074','Processed', '2023-01-23 09:09:09', 672, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (6, 'Tran Van Kien', 'Ton Quyen', 'Nghe An', 'Nghe An', 'Viet Nam', 'kientv@gmail.com', '0899932477', 'Processed', '2023-08-08 12:12:12', 400, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (7, 'Nguyen Huu Kien', 'Ho Quy Ly', 'Ha Tinh', 'Ha Tinh', 'Viet Nam', 'kiennh@gmail.com', '0845683321', 'Processed', '2023-2-5 10:34:23', 1959, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (7, 'Nguyen Thai Truong', 'Le Nhan Tong', 'Hai Duong', 'Hai Duong', 'Viet Nam', 'truongnt@gmail.com', '0823941123', 'Processed', '2021-11-19 11:23:53', 360, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (7, 'Nguyen Thi Le', 'Hung Dao Vuong', 'Ca Mau', 'Ca Mau', 'Viet Nam', 'lent@gmail.com', '0823112996', 'Processed', '2023-09-01 17:12:17', 1365, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (7, 'James Thomas', 'Connecticut Avenue NW', 'Washington', 'Washington', 'USA', 'thomasj@gmail.com', '05234268319', 'Processed', '2023-09-02 23:15:47', 1636.7, 1)
INSERT [Order] ([customerId], [receiver], [shipStreet], [shipCity], [shipProvince], [shipCountry], [shipEmail], [shipPhone], [status], [createdTime], [totalPrice],[active]) VALUES (9, 'Hanashi Aoi', 'Kabukicho', 'Tokyo', 'Tokyo', 'Japan', 'Aoihana@gmail.com', '0723539877', 'Processed', '2023-08-29 02:10:55', 320, 1)

INSERT [OrderDetails] ([productId], [orderId], [price], [quantity]) 
VALUES (1, 1, 180, 40),
	(9, 9, 520, 1),
	(2, 2, 220, 3),
	(3, 7, 280, 4),
	(6, 9, 100, 3),
	(3, 5, 280, 4),
	(6, 6, 100, 4),
	(9, 10, 520, 3),
	(7, 9, 320, 4),
	(4, 10, 199, 2),
	(12, 7, 240, 2),
	(3, 10, 280, 2),
	(12, 3, 240, 3),
	(9, 4, 520, 2),
	(1, 8, 180, 40),
	(8, 7, 333, 5),
	(2, 4, 220, 5),
	(7, 11, 320, 1)

INSERT [Cart] ([customerId]) 
VALUES (2),
	(4),
	(6),
	(7),
	(8),
	(9)

INSERT [CartItem] ([productId], [cartId], [price], [quantity]) 
VALUES (1, 1, 180, 4),
	(5, 1, 350, 2),
	(3, 2, 280, 3),
	(7, 3, 320, 1),
	(8, 3, 333, 4),
	(3, 3, 280, 2),
	(6, 5, 100, 2),
	(4, 5, 199, 1),
	(2, 6, 220, 3),
	(9, 5, 520, 6)

INSERT [ImportOrder] ([providerId], [managerId], [status], [createdTime],[active])
VALUES (1, 12, 'Received', '2022-12-11 8:25:31', 1),
	(1, 12, 'Accepted', '2023-9-21 8:52:12', 1),
	(1, 12, 'Canceled', '2022-07-25 8:47:42', 1),
	(2, 12, 'Received', '2023-05-28 9:02:03', 1),
	(2, 12, 'Accepted', '2023-8-22 8:59:25', 1),
	(3, 12, 'Received', '2023-03-29 9:12:53', 1)

INSERT [ImportOrderDetails] ([importOrderId], [productInfomration], [price], [quantity]) 
VALUES (1, 'Adidas Gazelle Shoes', 120, 50),
	(1, 'Adidas Ultraboost Light Running Shoes', 150, 80),
	(1, 'Adidas x Gucci ZX8000 Sneakers', 180, 70),
	(1, 'Adidas 4DFWD 2 Running Shoes', 130, 60),
	(4, 'Nike Roshe', 210, 90),
	(4, 'Nike Air Zoom Huarache 2K4', 60, 80),
	(4, 'Nike Waffle Racer', 190, 40),
	(4, 'Nike Air Zoom Generation', 200, 75),
	(6, 'PUMA RS-X', 360, 150),
	(6, 'Puma Slipstream', 90, 30),
	(6, 'PUMA Future Rider', 270, 70),
	(6, 'PUMA Clasico Trainers', 140, 60),
	(2, 'Adidas Gazelle Shoes', 120, 40),
	(2, 'Adidas Ultraboost Light Running Shoes', 150, 50),
	(2, 'Adidas x Gucci ZX8000 Sneakers', 180, 45),
	(3, 'Adidas 4DFWD 2 Running Shoes', 130, 35),
	(3, 'Adidas Gazelle Shoes', 120, 30),
	(5, 'Nike Roshe', 210, 60),
	(5, 'Nike Air Zoom Huarache 2K4', 60, 55),
	(5, 'Nike Air Zoom Generation', 200, 45)

INSERT [Voucher] ([code], [startDate], [endDate], [value], [active]) 
VALUES ('Voucher for Christmas', '2022-12-20 00:00:00', '2022-12-28 00:00:00', 30, 1),
	('Voucher for Tet holiday', '2023-01-20 00:00:00', '2023-02-20 00:00:00', 40, 1),
	('Voucher for Vietnam National Day', '2023-09-01 00:00:00', '2023-09-04 00:00:00', 35, 1),
	('Voucher for New Year holiday', '2022-12-28 00:00:00', '2023-01-03 00:00:00', 25, 1)

INSERT [Report] ([storageStaffId], [managerId], [title], [content], [writeDate],[readStatus])
VALUES (10, 5, 'Report title', 'asdfawfsf', '2023-01-03 00:00:00', 1)

Insert [Feedback] (customerId, productId, content, reply, feedbackDate, [checked])values (2 , 10,'Nice product',null, '2023-01-09 00:00:00', 0)
Insert [Feedback] (customerId, productId, content, reply, feedbackDate, [checked])values (2 , 10,'Nice shoes',null, '2023-01-03 00:00:00', 0)

Insert [Feedback] (customerId, productId, content, reply, feedbackDate, [checked])values (4 , 10,'Nice ones',null, '2023-04-03 00:00:00', 0)


USE master;
GO
ALTER DATABASE OnlineShop SET MULTI_USER;
GO
