--Estudiante: Vino Apaza Vanesa

USE [master]
GO
/****** Object:  Database [AirportSoport]    Script Date: 8/21/2024 1:28:48 PM ******/
CREATE DATABASE [AirportSoport]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AirportSoport', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AirportSoport.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AirportSoport_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AirportSoport_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AirportSoport] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AirportSoport].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AirportSoport] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AirportSoport] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AirportSoport] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AirportSoport] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AirportSoport] SET ARITHABORT OFF 
GO
ALTER DATABASE [AirportSoport] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [AirportSoport] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AirportSoport] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AirportSoport] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AirportSoport] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AirportSoport] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AirportSoport] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AirportSoport] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AirportSoport] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AirportSoport] SET  ENABLE_BROKER 
GO
ALTER DATABASE [AirportSoport] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AirportSoport] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AirportSoport] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AirportSoport] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AirportSoport] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AirportSoport] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AirportSoport] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AirportSoport] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AirportSoport] SET  MULTI_USER 
GO
ALTER DATABASE [AirportSoport] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AirportSoport] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AirportSoport] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AirportSoport] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AirportSoport] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AirportSoport] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AirportSoport] SET QUERY_STORE = ON
GO
ALTER DATABASE [AirportSoport] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AirportSoport]
GO
/****** Object:  Table [dbo].[Airplane]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Airplane](
	[Registration_Number] [int] NOT NULL,
	[Begin_of_Number] [date] NOT NULL,
	[Statuss] [varchar](50) NOT NULL,
	[Id_PlaneModel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Registration_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Airport]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Airport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Namee] [varchar](50) NOT NULL,
	[Id_City] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AvailableSeat]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailableSeat](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Id_Fligth] [int] NOT NULL,
	[Id_Seat] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Namee] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Namee] [varchar](30) NOT NULL,
	[Id_Country] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Namee] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coupon]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coupon](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date_of_Redemption] [date] NOT NULL,
	[Class] [varchar](20) NOT NULL,
	[Standbyy] [char](2) NOT NULL,
	[Meal_Code] [varchar](5) NOT NULL,
	[Id_Ticket] [int] NOT NULL,
	[Id_Flight] [int] NOT NULL,
	[Id_Available] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Ci] [int] NOT NULL,
	[Date_of_Birth] [date] NOT NULL,
	[Namee] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Ci] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Flight]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Flight](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Boarding_Time] [time](7) NOT NULL,
	[Flight_Date] [date] NOT NULL,
	[Gate] [int] NOT NULL,
	[Check_in_Counter] [varchar](20) NOT NULL,
	[Id_FlightNumber] [int] NOT NULL,
	[Id_Category] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlightNumber]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlightNumber](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Departure_Time] [time](7) NOT NULL,
	[Typee] [varchar](50) NOT NULL,
	[Airline] [varchar](100) NOT NULL,
	[Id_Start] [int] NOT NULL,
	[Id_Goal] [int] NOT NULL,
	[Id_Category] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FrequentFiyerCard]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FrequentFiyerCard](
	[FFC_Number] [int] NOT NULL,
	[Miles] [int] NOT NULL,
	[Meal_Code] [varchar](10) NOT NULL,
	[Ci_Customer] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FFC_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pasaport]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pasaport](
	[Pasoport_Number] [int] NOT NULL,
	[Country_of_issue] [int] NULL,
	[expiration_date] [date] NOT NULL,
	[Issue_Date] [date] NOT NULL,
	[Ci_Custumer] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Pasoport_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PiecesOfLuggage]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PiecesOfLuggage](
	[Number] [int] IDENTITY(1,1) NOT NULL,
	[Weightt] [decimal](18, 0) NOT NULL,
	[Id_Coupon] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlaneModel]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlaneModel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descriptionn] [varchar](50) NOT NULL,
	[Graphic] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seat]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seat](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Size] [int] NOT NULL,
	[Number] [int] NOT NULL,
	[Locationn] [varchar](50) NOT NULL,
	[Id_PlaneModel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ticket]    Script Date: 8/21/2024 1:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ticket](
	[Ticketing_Code] [int] NOT NULL,
	[Number] [int] NOT NULL,
	[Ci_Customer] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Ticketing_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3001, CAST(N'2020-01-15' AS Date), N'Active', 1)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3002, CAST(N'2020-03-22' AS Date), N'Active', 2)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3003, CAST(N'2019-05-30' AS Date), N'Inactive', 3)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3004, CAST(N'2018-11-10' AS Date), N'Active', 4)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3005, CAST(N'2021-07-05' AS Date), N'Active', 5)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3006, CAST(N'2017-08-18' AS Date), N'Inactive', 6)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3007, CAST(N'2022-02-25' AS Date), N'Active', 7)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3008, CAST(N'2016-12-01' AS Date), N'Active', 8)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3009, CAST(N'2019-09-14' AS Date), N'Inactive', 9)
INSERT [dbo].[Airplane] ([Registration_Number], [Begin_of_Number], [Statuss], [Id_PlaneModel]) VALUES (3010, CAST(N'2020-06-20' AS Date), N'Active', 10)
GO
SET IDENTITY_INSERT [dbo].[Airport] ON 

INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (1, N'John F. Kennedy International Airport', 1)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (2, N'Toronto Pearson International Airport', 2)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (3, N'Benito Juarez International Airport', 3)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (4, N'Galeão International Airport', 4)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (5, N'Ministro Pistarini International Airport', 5)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (6, N'Adolfo Suárez Madrid–Barajas Airport', 6)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (7, N'Charles de Gaulle Airport', 7)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (8, N'Berlin Brandenburg Airport', 8)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (9, N'Narita International Airport', 9)
INSERT [dbo].[Airport] ([Id], [Namee], [Id_City]) VALUES (10, N'Sydney Airport', 10)
SET IDENTITY_INSERT [dbo].[Airport] OFF
GO
SET IDENTITY_INSERT [dbo].[AvailableSeat] ON 

INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (1, 1, 1)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (2, 1, 2)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (3, 2, 3)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (4, 2, 4)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (5, 3, 5)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (6, 3, 6)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (7, 4, 7)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (8, 4, 8)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (9, 5, 9)
INSERT [dbo].[AvailableSeat] ([Id], [Id_Fligth], [Id_Seat]) VALUES (10, 5, 10)
SET IDENTITY_INSERT [dbo].[AvailableSeat] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([Id], [Namee]) VALUES (1, N'Economy')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (2, N'Business')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (3, N'First Class')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (4, N'Premium Economy')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (5, N'Basic Economy')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (6, N'Economy Plus')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (7, N'Business Plus')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (8, N'First Class Plus')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (9, N'Premium Business')
INSERT [dbo].[Category] ([Id], [Namee]) VALUES (10, N'Executive')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[City] ON 

INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (1, N'New York', 1)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (2, N'Toronto', 2)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (3, N'Mexico City', 3)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (4, N'Rio de Janeiro', 4)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (5, N'Buenos Aires', 5)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (6, N'Madrid', 6)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (7, N'Paris', 7)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (8, N'Berlin', 8)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (9, N'Tokyo', 9)
INSERT [dbo].[City] ([Id], [Namee], [Id_Country]) VALUES (10, N'Sydney', 10)
SET IDENTITY_INSERT [dbo].[City] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([Id], [Namee]) VALUES (1, N'USA')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (2, N'Canada')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (3, N'Mexico')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (4, N'Brazil')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (5, N'Argentina')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (6, N'Spain')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (7, N'France')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (8, N'Germany')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (9, N'Japan')
INSERT [dbo].[Country] ([Id], [Namee]) VALUES (10, N'Australia')
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[Coupon] ON 

INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (1, CAST(N'2024-08-22' AS Date), N'Economy', N'NO', N'VEG', 7001, 1, 1)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (2, CAST(N'2024-08-23' AS Date), N'Business', N'NO', N'NON', 7002, 2, 3)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (3, CAST(N'2024-08-24' AS Date), N'First Class', N'NO', N'VEG', 7003, 3, 5)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (4, CAST(N'2024-08-25' AS Date), N'Economy', N'NO', N'NON', 7004, 4, 7)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (5, CAST(N'2024-08-26' AS Date), N'Business', N'NO', N'VEG', 7005, 5, 9)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (6, CAST(N'2024-08-27' AS Date), N'Economy', N'NO', N'NON', 7006, 6, 2)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (7, CAST(N'2024-08-28' AS Date), N'First Class', N'NO', N'VEG', 7007, 7, 4)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (8, CAST(N'2024-08-29' AS Date), N'Business', N'NO', N'NON', 7008, 8, 6)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (9, CAST(N'2024-08-30' AS Date), N'Economy', N'NO', N'VEG', 7009, 9, 8)
INSERT [dbo].[Coupon] ([Id], [Date_of_Redemption], [Class], [Standbyy], [Meal_Code], [Id_Ticket], [Id_Flight], [Id_Available]) VALUES (10, CAST(N'2024-08-31' AS Date), N'First Class', N'NO', N'NON', 7010, 10, 10)
SET IDENTITY_INSERT [dbo].[Coupon] OFF
GO
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1001, CAST(N'1980-05-15' AS Date), N'John Doe')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1002, CAST(N'1985-09-22' AS Date), N'Jane Smith')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1003, CAST(N'1990-12-10' AS Date), N'Carlos Garcia')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1004, CAST(N'1975-03-05' AS Date), N'Maria Hernandez')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1005, CAST(N'1988-07-30' AS Date), N'David Brown')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1006, CAST(N'1992-11-18' AS Date), N'Emily Suarez')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1007, CAST(N'1970-01-25' AS Date), N'Michael Born')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1008, CAST(N'1995-04-09' AS Date), N'Laura Garcia')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1009, CAST(N'1982-06-21' AS Date), N'Robert Kitmeru')
INSERT [dbo].[Customer] ([Ci], [Date_of_Birth], [Namee]) VALUES (1010, CAST(N'1998-08-14' AS Date), N'Sophia Perez')
GO
SET IDENTITY_INSERT [dbo].[Flight] ON 

INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (1, CAST(N'09:30:00' AS Time), CAST(N'2024-08-21' AS Date), 1, N'A01', 1, 1)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (2, CAST(N'11:30:00' AS Time), CAST(N'2024-08-21' AS Date), 2, N'B02', 2, 2)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (3, CAST(N'14:30:00' AS Time), CAST(N'2024-08-21' AS Date), 3, N'C03', 3, 3)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (4, CAST(N'07:30:00' AS Time), CAST(N'2024-08-21' AS Date), 4, N'D04', 4, 4)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (5, CAST(N'17:30:00' AS Time), CAST(N'2024-08-21' AS Date), 5, N'E05', 5, 5)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (6, CAST(N'13:30:00' AS Time), CAST(N'2024-08-21' AS Date), 6, N'F06', 6, 6)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (7, CAST(N'10:30:00' AS Time), CAST(N'2024-08-21' AS Date), 7, N'G07', 7, 7)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (8, CAST(N'12:30:00' AS Time), CAST(N'2024-08-21' AS Date), 8, N'H08', 8, 8)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (9, CAST(N'15:30:00' AS Time), CAST(N'2024-08-21' AS Date), 9, N'I09', 9, 9)
INSERT [dbo].[Flight] ([Id], [Boarding_Time], [Flight_Date], [Gate], [Check_in_Counter], [Id_FlightNumber], [Id_Category]) VALUES (10, CAST(N'18:30:00' AS Time), CAST(N'2024-08-21' AS Date), 10, N'J10', 10, 10)
SET IDENTITY_INSERT [dbo].[Flight] OFF
GO
SET IDENTITY_INSERT [dbo].[FlightNumber] ON 

INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (1, CAST(N'10:00:00' AS Time), N'Domestic', N'American Airlines', 1, 2, 1)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (2, CAST(N'12:00:00' AS Time), N'International', N'Air Canada', 2, 3, 2)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (3, CAST(N'15:00:00' AS Time), N'Domestic', N'Aeromexico', 3, 4, 3)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (4, CAST(N'08:00:00' AS Time), N'International', N'LATAM', 4, 5, 4)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (5, CAST(N'18:00:00' AS Time), N'Domestic', N'Aerolineas Argentinas', 5, 6, 5)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (6, CAST(N'14:00:00' AS Time), N'International', N'Iberia', 6, 7, 6)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (7, CAST(N'11:00:00' AS Time), N'Domestic', N'Air France', 7, 8, 7)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (8, CAST(N'13:00:00' AS Time), N'International', N'Lufthansa', 8, 9, 8)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (9, CAST(N'09:00:00' AS Time), N'Domestic', N'ANA', 9, 10, 9)
INSERT [dbo].[FlightNumber] ([Id], [Departure_Time], [Typee], [Airline], [Id_Start], [Id_Goal], [Id_Category]) VALUES (10, CAST(N'17:00:00' AS Time), N'International', N'Qantas', 10, 1, 10)
SET IDENTITY_INSERT [dbo].[FlightNumber] OFF
GO
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4001, 50000, N'VEG', 1001)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4002, 35000, N'NON', 1002)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4003, 20000, N'VEG', 1003)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4004, 45000, N'NON', 1004)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4005, 55000, N'VEG', 1005)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4006, 60000, N'NON', 1006)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4007, 70000, N'VEG', 1007)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4008, 25000, N'NON', 1008)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4009, 80000, N'VEG', 1009)
INSERT [dbo].[FrequentFiyerCard] ([FFC_Number], [Miles], [Meal_Code], [Ci_Customer]) VALUES (4010, 65000, N'NON', 1010)
GO
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5001, 1, CAST(N'2030-05-15' AS Date), CAST(N'2020-05-15' AS Date), 1001)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5002, 2, CAST(N'2031-09-22' AS Date), CAST(N'2021-09-22' AS Date), 1002)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5003, 3, CAST(N'2032-12-10' AS Date), CAST(N'2022-12-10' AS Date), 1003)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5004, 4, CAST(N'2029-03-05' AS Date), CAST(N'2019-03-05' AS Date), 1004)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5005, 5, CAST(N'2033-07-30' AS Date), CAST(N'2023-07-30' AS Date), 1005)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5006, 6, CAST(N'2028-11-18' AS Date), CAST(N'2018-11-18' AS Date), 1006)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5007, 7, CAST(N'2027-01-25' AS Date), CAST(N'2017-01-25' AS Date), 1007)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5008, 8, CAST(N'2034-04-09' AS Date), CAST(N'2024-04-09' AS Date), 1008)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5009, 9, CAST(N'2026-06-21' AS Date), CAST(N'2016-06-21' AS Date), 1009)
INSERT [dbo].[Pasaport] ([Pasoport_Number], [Country_of_issue], [expiration_date], [Issue_Date], [Ci_Custumer]) VALUES (5010, 10, CAST(N'2035-08-14' AS Date), CAST(N'2025-08-14' AS Date), 1010)
GO
SET IDENTITY_INSERT [dbo].[PiecesOfLuggage] ON 

INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (1, CAST(24 AS Decimal(18, 0)), 1)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (2, CAST(18 AS Decimal(18, 0)), 2)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (3, CAST(25 AS Decimal(18, 0)), 3)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (4, CAST(20 AS Decimal(18, 0)), 4)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (5, CAST(22 AS Decimal(18, 0)), 5)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (6, CAST(20 AS Decimal(18, 0)), 6)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (7, CAST(22 AS Decimal(18, 0)), 7)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (8, CAST(25 AS Decimal(18, 0)), 8)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (9, CAST(18 AS Decimal(18, 0)), 9)
INSERT [dbo].[PiecesOfLuggage] ([Number], [Weightt], [Id_Coupon]) VALUES (10, CAST(26 AS Decimal(18, 0)), 10)
SET IDENTITY_INSERT [dbo].[PiecesOfLuggage] OFF
GO
SET IDENTITY_INSERT [dbo].[PlaneModel] ON 

INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (1, N'Boeing 747', N'boeing747.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (2, N'Airbus A320', N'airbusA320.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (3, N'Boeing 737', N'boeing737.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (4, N'Airbus A380', N'airbusA380.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (5, N'Boeing 777', N'boeing777.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (6, N'Airbus A330', N'airbusA330.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (7, N'Boeing 787', N'boeing787.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (8, N'Airbus A350', N'airbusA350.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (9, N'Boeing 767', N'boeing767.png')
INSERT [dbo].[PlaneModel] ([Id], [Descriptionn], [Graphic]) VALUES (10, N'Airbus A340', N'airbusA340.png')
SET IDENTITY_INSERT [dbo].[PlaneModel] OFF
GO
SET IDENTITY_INSERT [dbo].[Seat] ON 

INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (1, 32, 1, N'Window', 1)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (2, 32, 2, N'Aisle', 1)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (3, 32, 3, N'Window', 2)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (4, 34, 4, N'Aisle', 2)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (5, 34, 5, N'Window', 3)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (6, 35, 6, N'Aisle', 3)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (7, 33, 7, N'Window', 4)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (8, 33, 8, N'Aisle', 4)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (9, 32, 9, N'Window', 5)
INSERT [dbo].[Seat] ([Id], [Size], [Number], [Locationn], [Id_PlaneModel]) VALUES (10, 32, 10, N'Aisle', 5)
SET IDENTITY_INSERT [dbo].[Seat] OFF
GO
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7001, 1001, 1001)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7002, 1002, 1002)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7003, 1003, 1003)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7004, 1004, 1004)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7005, 1005, 1005)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7006, 1006, 1006)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7007, 1007, 1007)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7008, 1008, 1008)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7009, 1009, 1009)
INSERT [dbo].[Ticket] ([Ticketing_Code], [Number], [Ci_Customer]) VALUES (7010, 1010, 1010)
GO
ALTER TABLE [dbo].[Airplane]  WITH CHECK ADD FOREIGN KEY([Id_PlaneModel])
REFERENCES [dbo].[PlaneModel] ([Id])
GO
ALTER TABLE [dbo].[Airport]  WITH CHECK ADD FOREIGN KEY([Id_City])
REFERENCES [dbo].[City] ([Id])
GO
ALTER TABLE [dbo].[AvailableSeat]  WITH CHECK ADD FOREIGN KEY([Id_Fligth])
REFERENCES [dbo].[Flight] ([Id])
GO
ALTER TABLE [dbo].[AvailableSeat]  WITH CHECK ADD FOREIGN KEY([Id_Seat])
REFERENCES [dbo].[Seat] ([Id])
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD FOREIGN KEY([Id_Country])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Coupon]  WITH CHECK ADD FOREIGN KEY([Id_Available])
REFERENCES [dbo].[AvailableSeat] ([Id])
GO
ALTER TABLE [dbo].[Coupon]  WITH CHECK ADD FOREIGN KEY([Id_Flight])
REFERENCES [dbo].[Flight] ([Id])
GO
ALTER TABLE [dbo].[Coupon]  WITH CHECK ADD FOREIGN KEY([Id_Ticket])
REFERENCES [dbo].[Ticket] ([Ticketing_Code])
GO
ALTER TABLE [dbo].[Flight]  WITH CHECK ADD FOREIGN KEY([Id_Category])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[Flight]  WITH CHECK ADD FOREIGN KEY([Id_FlightNumber])
REFERENCES [dbo].[FlightNumber] ([Id])
GO
ALTER TABLE [dbo].[FlightNumber]  WITH CHECK ADD FOREIGN KEY([Id_Goal])
REFERENCES [dbo].[Airport] ([Id])
GO
ALTER TABLE [dbo].[FlightNumber]  WITH CHECK ADD FOREIGN KEY([Id_Start])
REFERENCES [dbo].[Airport] ([Id])
GO
ALTER TABLE [dbo].[FrequentFiyerCard]  WITH CHECK ADD FOREIGN KEY([Ci_Customer])
REFERENCES [dbo].[Customer] ([Ci])
GO
ALTER TABLE [dbo].[Pasaport]  WITH CHECK ADD FOREIGN KEY([Ci_Custumer])
REFERENCES [dbo].[Customer] ([Ci])
GO
ALTER TABLE [dbo].[PiecesOfLuggage]  WITH CHECK ADD FOREIGN KEY([Id_Coupon])
REFERENCES [dbo].[Coupon] ([Id])
GO
ALTER TABLE [dbo].[Seat]  WITH CHECK ADD FOREIGN KEY([Id_PlaneModel])
REFERENCES [dbo].[PlaneModel] ([Id])
GO
ALTER TABLE [dbo].[Ticket]  WITH CHECK ADD FOREIGN KEY([Ci_Customer])
REFERENCES [dbo].[Customer] ([Ci])
GO
USE [master]
GO
ALTER DATABASE [AirportSoport] SET  READ_WRITE 
GO
