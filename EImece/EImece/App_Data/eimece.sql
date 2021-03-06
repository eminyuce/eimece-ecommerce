USE [master]
GO
/****** Object:  Database [eimece]    Script Date: 4/28/2022 11:44:15 PM ******/
CREATE DATABASE [eimece]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'eimece', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\eimece.mdf' , SIZE = 17600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'eimece_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\eimece_log.ldf' , SIZE = 321088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [eimece] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [eimece].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [eimece] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [eimece] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [eimece] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [eimece] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [eimece] SET ARITHABORT OFF 
GO
ALTER DATABASE [eimece] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [eimece] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [eimece] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [eimece] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [eimece] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [eimece] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [eimece] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [eimece] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [eimece] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [eimece] SET  ENABLE_BROKER 
GO
ALTER DATABASE [eimece] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [eimece] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [eimece] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [eimece] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [eimece] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [eimece] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [eimece] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [eimece] SET RECOVERY FULL 
GO
ALTER DATABASE [eimece] SET  MULTI_USER 
GO
ALTER DATABASE [eimece] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [eimece] SET DB_CHAINING OFF 
GO
ALTER DATABASE [eimece] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [eimece] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [eimece] SET DELAYED_DURABILITY = DISABLED 
GO
USE [eimece]
GO
/****** Object:  User [emin]    Script Date: 4/28/2022 11:44:15 PM ******/
CREATE USER [emin] FOR LOGIN [emin] WITH DEFAULT_SCHEMA=[emin]
GO
/****** Object:  User [eimeceroot]    Script Date: 4/28/2022 11:44:15 PM ******/
CREATE USER [eimeceroot] FOR LOGIN [eimeceroot] WITH DEFAULT_SCHEMA=[eimeceroot]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [emin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [emin]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [emin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [emin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [emin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [eimeceroot]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [eimeceroot]
GO
ALTER ROLE [db_datareader] ADD MEMBER [eimeceroot]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [eimeceroot]
GO
/****** Object:  Schema [eimeceroot]    Script Date: 4/28/2022 11:44:16 PM ******/
CREATE SCHEMA [eimeceroot]
GO
/****** Object:  Schema [emin]    Script Date: 4/28/2022 11:44:16 PM ******/
CREATE SCHEMA [emin]
GO
/****** Object:  Schema [Tzdb]    Script Date: 4/28/2022 11:44:16 PM ******/
CREATE SCHEMA [Tzdb]
GO
/****** Object:  UserDefinedTableType [dbo].[ei_tpt_Filter]    Script Date: 4/28/2022 11:44:16 PM ******/
CREATE TYPE [dbo].[ei_tpt_Filter] AS TABLE(
	[FieldName] [nvarchar](max) NULL,
	[ValueFirst] [nvarchar](max) NULL,
	[ValueLast] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [Tzdb].[IntervalTable]    Script Date: 4/28/2022 11:44:16 PM ******/
CREATE TYPE [Tzdb].[IntervalTable] AS TABLE(
	[UtcStart] [datetime2](0) NOT NULL,
	[UtcEnd] [datetime2](0) NOT NULL,
	[LocalStart] [datetime2](0) NOT NULL,
	[LocalEnd] [datetime2](0) NOT NULL,
	[OffsetMinutes] [smallint] NOT NULL,
	[Abbreviation] [varchar](10) NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetRandomNumber]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetRandomNumber](@lowerLimit BIGINT, @upperLimit BIGINT, @GuidValue UNIQUEIDENTIFIER)
RETURNS BIGINT
AS
BEGIN
    RETURN
    (
    SELECT ABS(CAST(CAST(@GuidValue AS VARBINARY(8)) AS BIGINT)) % (@upperLimit-@lowerLimit)+@lowerLimit
    )
END
GO
/****** Object:  UserDefinedFunction [dbo].[ProductRating]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductRating](@ProductId INT)
RETURNS float
AS
BEGIN 
	declare @rating float;
SELECT
  @rating =   ISNULL( CAST(AVG(Cast(Rating as float)) AS DECIMAL(10,2)),0)
FROM
   [dbo].[ProductComments] where ProductId=@ProductId and IsActive = 1;
   RETURN @rating;
END 
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[Id] [int] IDENTITY(2000,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Street] [nvarchar](500) NULL,
	[District] [nvarchar](500) NULL,
	[ZipCode] [nvarchar](500) NULL,
	[City] [nvarchar](500) NOT NULL,
	[Country] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[AddressType] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppLogs]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventDateTime] [nvarchar](max) NULL,
	[EventLevel] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[MachineName] [nvarchar](max) NULL,
	[EventMessage] [nvarchar](max) NULL,
	[ErrorSource] [nvarchar](max) NULL,
	[ErrorClass] [nvarchar](max) NULL,
	[ErrorMethod] [nvarchar](max) NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[InnerErrorMessage] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AppLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[FirstName] [nvarchar](256) NULL,
	[LastName] [nvarchar](256) NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brands]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[MainPage] [bit] NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NULL,
	[MainImageId] [int] NULL,
	[Lang] [int] NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Brands] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coupons]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coupons](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[DiscountPercentage] [int] NOT NULL,
	[Discount] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Coupon] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Coupons] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NULL,
	[CustomerType] [int] NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Company] [nvarchar](500) NULL,
	[Email] [nvarchar](100) NULL,
	[GsmNumber] [nvarchar](100) NULL,
	[IdentityNumber] [nvarchar](100) NULL,
	[Ip] [nvarchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[Position] [int] NULL,
	[Lang] [int] NULL,
	[IsPermissionGranted] [bit] NULL,
	[Gender] [int] NULL,
	[City] [nvarchar](500) NULL,
	[Town] [nvarchar](500) NULL,
	[District] [nvarchar](500) NULL,
	[Street] [nvarchar](500) NULL,
	[ZipCode] [nvarchar](500) NULL,
	[Country] [nvarchar](500) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[db_error_LearningErrorLog]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[db_error_LearningErrorLog](
	[ErrorID] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorNumber] [nvarchar](50) NOT NULL,
	[ErrorDescription] [nvarchar](4000) NULL,
	[ErrorProcedure] [nvarchar](100) NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faqs]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faqs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
	[Question] [nvarchar](max) NULL,
	[Answer] [nvarchar](max) NULL,
	[AddUserId] [nvarchar](100) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Faqs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileStorages]    Script Date: 4/28/2022 11:44:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileStorages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[FileName] [nvarchar](500) NOT NULL,
	[FileUrl] [nvarchar](500) NULL,
	[MimeType] [nvarchar](50) NOT NULL,
	[FileSize] [int] NOT NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[Type] [nvarchar](50) NULL,
	[Lang] [int] NOT NULL,
	[IsFileExist] [bit] NULL,
 CONSTRAINT [PK_FileStorages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileStorageTags]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileStorageTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileStorageId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
 CONSTRAINT [PK_FileStorageTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListItems]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ListId] [int] NULL,
	[Name] [nvarchar](500) NULL,
	[Value] [nvarchar](500) NULL,
	[Position] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_ListItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lists]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[IsService] [bit] NULL,
	[IsValues] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[Position] [int] NULL,
	[IsActive] [bit] NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_Lists] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MailTemplates]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MailTemplates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Position] [int] NULL,
	[Lang] [int] NULL,
	[Subject] [nvarchar](500) NULL,
	[Body] [nvarchar](max) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
	[TrackWithBitly] [bit] NULL,
	[TrackWithMlnk] [bit] NULL,
 CONSTRAINT [PK_MailTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MainPageImages]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MainPageImages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NULL,
	[Link] [nvarchar](500) NULL,
	[MainImageId] [int] NULL,
	[Lang] [int] NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_MainPageImages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuFiles]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuFiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NULL,
	[FileStorageId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_MenuFiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menus]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NULL,
	[MainPage] [bit] NULL,
	[LinkIsActive] [bit] NULL,
	[Link] [nvarchar](500) NULL,
	[MainImageId] [int] NULL,
	[MenuLink] [nvarchar](500) NOT NULL,
	[PageTheme] [nvarchar](50) NULL,
	[Lang] [int] NOT NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[AddUserId] [nvarchar](100) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderProducts]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderProducts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[ProductSpecItems] [nvarchar](4000) NULL,
	[ProductSalePrice] [money] NULL,
	[ProductName] [nvarchar](500) NULL,
	[ProductCode] [nvarchar](500) NULL,
	[CategoryName] [nvarchar](500) NULL,
 CONSTRAINT [PK_Order_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderType] [int] NULL,
	[BillingAddressId] [int] NULL,
	[ShippingAddressId] [int] NULL,
	[OrderNumber] [nvarchar](50) NULL,
	[CargoPrice] [money] NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[OrderGuid] [nvarchar](100) NULL,
	[Name] [nvarchar](500) NOT NULL,
	[OrderComments] [nvarchar](4000) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[OrderStatus] [int] NULL,
	[AdminOrderNote] [nvarchar](4000) NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[CouponDiscount] [nvarchar](100) NULL,
	[Coupon] [nvarchar](100) NULL,
	[Token] [nvarchar](100) NULL,
	[Price] [nvarchar](100) NULL,
	[PaidPrice] [nvarchar](100) NULL,
	[Installment] [nvarchar](100) NULL,
	[Currency] [nvarchar](50) NULL,
	[PaymentId] [nvarchar](100) NULL,
	[PaymentStatus] [nvarchar](100) NULL,
	[FraudStatus] [int] NULL,
	[MerchantCommissionRate] [nvarchar](100) NULL,
	[MerchantCommissionRateAmount] [nvarchar](100) NULL,
	[IyziCommissionRateAmount] [nvarchar](100) NULL,
	[IyziCommissionFee] [nvarchar](100) NULL,
	[CardType] [nvarchar](100) NULL,
	[CardAssociation] [nvarchar](100) NULL,
	[CardFamily] [nvarchar](100) NULL,
	[CardToken] [nvarchar](200) NULL,
	[CardUserKey] [nvarchar](100) NULL,
	[BinNumber] [nvarchar](100) NULL,
	[LastFourDigits] [nvarchar](100) NULL,
	[BasketId] [nvarchar](100) NULL,
	[ConversationId] [nvarchar](100) NULL,
	[ConnectorName] [nvarchar](100) NULL,
	[AuthCode] [nvarchar](100) NULL,
	[HostReference] [nvarchar](100) NULL,
	[Phase] [nvarchar](100) NULL,
	[Status] [nvarchar](100) NULL,
	[ErrorCode] [nvarchar](100) NULL,
	[ErrorMessage] [nvarchar](500) NULL,
	[Locale] [nvarchar](100) NULL,
	[SystemTime] [bigint] NULL,
	[ShipmentTrackingNumber] [nvarchar](200) NULL,
	[ShipmentCompanyName] [nvarchar](200) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductCategories]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[ShortDescription] [nvarchar](4000) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NULL,
	[MainPage] [bit] NULL,
	[MainImageId] [int] NULL,
	[Lang] [int] NOT NULL,
	[TemplateId] [int] NULL,
	[DiscountPercantage] [float] NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_ProductCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductComments]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductComments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Subject] [nvarchar](50) NULL,
	[Review] [nvarchar](4000) NOT NULL,
	[Rating] [int] NULL,
	[UserId] [nvarchar](128) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
 CONSTRAINT [PK_ProductComments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductFiles]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductFiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[FileStorageId] [int] NULL,
	[Name] [nvarchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_ProductFiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BrandId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[NameLong] [nvarchar](1000) NULL,
	[NameShort] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ShortDescription] [nvarchar](4000) NULL,
	[MainPage] [bit] NOT NULL,
	[ImageState] [bit] NOT NULL,
	[MainImageId] [int] NULL,
	[ProductCategoryId] [int] NOT NULL,
	[Price] [money] NULL,
	[Discount] [money] NULL,
	[ProductCode] [nvarchar](255) NULL,
	[Lang] [int] NOT NULL,
	[VideoUrl] [nvarchar](1000) NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[IsCampaign] [bit] NULL,
	[AddUserId] [nvarchar](100) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[Rating]  AS ([dbo].[ProductRating]([Id])),
	[ProductColorOptions] [nvarchar](1000) NULL,
	[ProductSizeOptions] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSpecifications]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSpecifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[Name] [nvarchar](1000) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Value] [nvarchar](1000) NOT NULL,
	[Unit] [nvarchar](1000) NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_ProductSpecifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTags]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TagId] [int] NULL,
	[ProductId] [int] NULL,
 CONSTRAINT [PK_ProductTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[SettingKey] [nvarchar](255) NOT NULL,
	[SettingValue] [nvarchar](4000) NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCarts]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCarts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderGuid] [nvarchar](100) NULL,
	[UserId] [nvarchar](150) NULL,
	[ShoppingCartJson] [nvarchar](max) NULL,
	[Name] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Position] [int] NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_ShoppingCarts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShortUrls]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShortUrls](
	[Id] [int] IDENTITY(100,1) NOT NULL,
	[Name] [nvarchar](2000) NULL,
	[UrlKey] [nvarchar](100) NULL,
	[Url] [nvarchar](2000) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[RequestCount] [int] NULL,
	[IsActive] [bit] NULL,
	[Position] [int] NULL,
	[Lang] [nvarchar](10) NULL,
 CONSTRAINT [PK_ShortUrls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stories]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoryCategoryId] [int] NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[AuthorName] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[MainPage] [bit] NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NULL,
	[IsFeaturedStory] [bit] NULL,
	[MainImageId] [int] NULL,
	[Lang] [int] NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Stories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoryCategories]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoryCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ImageState] [bit] NOT NULL,
	[MainImageId] [int] NULL,
	[Lang] [int] NOT NULL,
	[PageTheme] [nvarchar](50) NULL,
	[MetaKeywords] [nvarchar](1000) NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_StoryCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoryFiles]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoryFiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoryId] [int] NULL,
	[FileStorageId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NULL,
 CONSTRAINT [PK_StoryFiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoryTags]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoryTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoryId] [int] NULL,
	[TagId] [int] NULL,
 CONSTRAINT [PK_StoryTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subscribers]    Script Date: 4/28/2022 11:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscribers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Email] [nvarchar](500) NULL,
	[Lang] [int] NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_Subscribers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagCategories]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TagCategoryId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[Lang] [int] NOT NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Templates]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Templates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Position] [int] NOT NULL,
	[TemplateXml] [nvarchar](max) NULL,
	[Lang] [int] NOT NULL,
	[UpdateUserId] [nvarchar](100) NULL,
	[AddUserId] [nvarchar](100) NULL,
 CONSTRAINT [PK_Templates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppLogs] ADD  CONSTRAINT [DF_AppLogs_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FileStorages] ADD  CONSTRAINT [DF_FileStorages_IsFileExist]  DEFAULT ((1)) FOR [IsFileExist]
GO
ALTER TABLE [dbo].[ListItems] ADD  CONSTRAINT [DF_ListItems_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ListItems] ADD  CONSTRAINT [DF_ListItems_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Menus] ADD  CONSTRAINT [DF_Menus_ParentId]  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Position]  DEFAULT ((0)) FOR [Position]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_ParentId]  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_Position]  DEFAULT ((1)) FOR [Position]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_ImageState]  DEFAULT ((0)) FOR [ImageState]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_MainPage]  DEFAULT ((0)) FOR [MainPage]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_Lang]  DEFAULT ((1)) FOR [Lang]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Position]  DEFAULT ((1)) FOR [Position]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_MainPage]  DEFAULT ((1)) FOR [MainPage]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ImageState]  DEFAULT ((0)) FOR [ImageState]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ProductCategoryId]  DEFAULT ((0)) FOR [ProductCategoryId]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Discount]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Lang]  DEFAULT ((1)) FOR [Lang]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsCampaign]  DEFAULT ((0)) FOR [IsCampaign]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[ListItems]  WITH CHECK ADD  CONSTRAINT [FK_ListItems_Lists] FOREIGN KEY([ListId])
REFERENCES [dbo].[Lists] ([Id])
GO
ALTER TABLE [dbo].[ListItems] CHECK CONSTRAINT [FK_ListItems_Lists]
GO
ALTER TABLE [dbo].[OrderProducts]  WITH CHECK ADD  CONSTRAINT [FK_Order_Products_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[OrderProducts] CHECK CONSTRAINT [FK_Order_Products_Products]
GO
ALTER TABLE [dbo].[OrderProducts]  WITH CHECK ADD  CONSTRAINT [FK_OrderProducts_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderProducts] CHECK CONSTRAINT [FK_OrderProducts_Orders]
GO
ALTER TABLE [dbo].[ProductFiles]  WITH CHECK ADD  CONSTRAINT [FK_ProductFiles_FileStorages] FOREIGN KEY([FileStorageId])
REFERENCES [dbo].[FileStorages] ([Id])
GO
ALTER TABLE [dbo].[ProductFiles] CHECK CONSTRAINT [FK_ProductFiles_FileStorages]
GO
ALTER TABLE [dbo].[ProductFiles]  WITH CHECK ADD  CONSTRAINT [FK_ProductFiles_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ProductFiles] CHECK CONSTRAINT [FK_ProductFiles_Products]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_ProductCategories] FOREIGN KEY([ProductCategoryId])
REFERENCES [dbo].[ProductCategories] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_ProductCategories]
GO
ALTER TABLE [dbo].[ProductSpecifications]  WITH CHECK ADD  CONSTRAINT [FK_ProductSpecifications_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ProductSpecifications] CHECK CONSTRAINT [FK_ProductSpecifications_Products]
GO
ALTER TABLE [dbo].[ProductTags]  WITH CHECK ADD  CONSTRAINT [FK_ProductTags_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ProductTags] CHECK CONSTRAINT [FK_ProductTags_Products]
GO
ALTER TABLE [dbo].[Stories]  WITH CHECK ADD  CONSTRAINT [FK_Stories_StoryCategories] FOREIGN KEY([StoryCategoryId])
REFERENCES [dbo].[StoryCategories] ([Id])
GO
ALTER TABLE [dbo].[Stories] CHECK CONSTRAINT [FK_Stories_StoryCategories]
GO
/****** Object:  StoredProcedure [dbo].[db_error_Learning_Insert_ErrorLog]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE 
  PROCEDURE [dbo].[db_error_Learning_Insert_ErrorLog]
AS
BEGIN
SET NOCOUNT ON 
        
         INSERT INTO [db_error_LearningErrorLog]  
             (
             ErrorNumber 
            ,ErrorDescription 
            ,ErrorProcedure 
            ,ErrorState 
            ,ErrorSeverity 
            ,ErrorLine 
            ,ErrorTime 
           )
           VALUES
           (
             ERROR_NUMBER()
            ,ERROR_MESSAGE()
            ,ERROR_PROCEDURE()
            ,ERROR_STATE()
            ,ERROR_SEVERITY()
            ,ERROR_LINE()
            ,GETDATE()  
           );
    
SET NOCOUNT OFF    
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteAllData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAllData]
	 @test int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
TRUNCATE TABLE ProductTags
TRUNCATE TABLE ProductSpecifications
TRUNCATE TABLE ProductFiles
TRUNCATE TABLE Products
TRUNCATE TABLE ProductCategories



TRUNCATE TABLE FileStorages
TRUNCATE TABLE FileStorageTags
TRUNCATE TABLE ListItems
TRUNCATE TABLE Lists
TRUNCATE TABLE MainPageImages
TRUNCATE TABLE MenuFiles
TRUNCATE TABLE Menus




--TRUNCATE TABLE Settings
TRUNCATE TABLE Stories
TRUNCATE TABLE StoryCategories
TRUNCATE TABLE StoryFiles
TRUNCATE TABLE StoryTags
TRUNCATE TABLE Subscribers
TRUNCATE TABLE TagCategories
TRUNCATE TABLE Tags
TRUNCATE TABLE MailTemplates

--TRUNCATE TABLE Templates

END

GO
/****** Object:  StoredProcedure [dbo].[ei_sp_SearchProducts]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/*

  DECLARE @filter as ei_tpt_Filter
 
 -- INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('company','raymarine','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Included Qty x Type','USB adapter - 5 pin Micro-USB Type B ( female ) - Apple Dock connector ( male ) USB cable - 5 pin Micro-USB Type B ( male ) - 4 pin USB Type A ( male )','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Warranty','1 Year','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Part Numbers','CW13632','') 
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Depth','1.5','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast)  VALUES ('Low Voltage Power','20','')
 

exec [dbo].[ei_sp_SearchProducts] @search = '', @top = 100, @skip = 0, @filter= @filter



 
 select * from  dbo.Products where ProductID = 5521
 
 
 select * from   dbo.ProductsSpecValues psv
	    
			WHERE  ProductSpecID=152 AND ValueString= 'USB adapter - 5 pin Micro-USB Type B ( female ) - Apple Dock connector ( male ) USB cable - 5 pin Micro-USB Type B ( male ) - 4 pin USB Type A ( male )'
 

*/
CREATE PROCEDURE [dbo].[ei_sp_SearchProducts]
	@search nvarchar(200)='',
	@top int=20,
	@skip int=0,
	@language int=1,
	@filter AS dbo.ei_tpt_Filter Readonly 
AS
BEGIN

	SET NOCOUNT ON;
	
/*	
IF EXISTS(select name from tempdb..sysobjects  where name like '#recordFound') drop table #recordFound
 */
 
CREATE TABLE #recordFound (ProductId int, ProductCategoryId int, FiltersMatched int)
CREATE INDEX IDX_Product_RecordFound ON #recordFound(ProductId,ProductCategoryId)

 
INSERT INTO #recordFound (ProductId,ProductCategoryId, FiltersMatched)
SELECT Id,[ProductCategoryId], 0
FROM dbo.Products as p
 where 	p.IsActive=1 and p.Lang = @language
 



DECLARE cFilters CURSOR FOR  
SELECT FieldName, ValueFirst,ValueLast
FROM @filter

DECLARE @FieldName VARCHAR(max)
DECLARE @ValueFirst VARCHAR(max)
DECLARE @ValueLast VARCHAR(max)

OPEN cFilters  
FETCH NEXT FROM cFilters INTO @FieldName,  @ValueFirst, @ValueLast 

 
WHILE @@FETCH_STATUS = 0  
BEGIN  

	-- 
    
	
 

	IF @FieldName='Category'
	BEGIN
		UPDATE rf
			SET FiltersMatched=FiltersMatched+1
		FROM 
		 #recordFound rf 
		 INNER JOIN 
		 (
			SELECT DISTINCT   b.Id ProductId
			FROM         Products b INNER JOIN
						 ProductsCategories cb ON b.[ProductCategoryId] = cb.Id
			WHERE cb.Name=@ValueFirst and 	b.IsActive=1
		  ) m
		  ON rf.ProductId = m.ProductId
	END
	
	
 
 
	
	FETCH NEXT FROM cFilters INTO @FieldName,  @ValueFirst, @ValueLast 

END  

CLOSE cFilters  
DEALLOCATE cFilters 

  --select * from  #recordFound where FiltersMatched > 0 

 DELETE FROM #recordFound  WHERE FiltersMatched<(SELECT COUNT(*) FROM @filter)






CREATE TABLE #recordFound2 (ProductID int,  ProductCategoryId int,  rowNumber int)
CREATE INDEX IDX_Product_RecordFound2 ON #recordFound2(ProductId,ProductCategoryId)



  
		IF (LEN (ISNULL(@search,''))>0)  
		BEGIN
				INSERT INTO  #recordFound2 (ProductID ,ProductCategoryId, rowNumber )
				SELECT rf.ProductID , rf.ProductCategoryId, 	ROW_NUMBER() OVER (ORDER BY [RANK] DESC, rf.ProductID) AS rowNumber 
				FROM #recordFound rf INNER JOIN
				(
					SELECT s.ItemId as ProductID, ft.[RANK] as [RANK] 
						FROM  ProductSearch s  
						INNER JOIN 	FREETEXTTABLE (dbo.ProductSearch, *, @search) ft ON s.[SearchId]=ft.[Key]
					WHERE s.ItemType=2 
				) fts
				ON rf.ProductID=fts.ProductID
			
				order by rowNumber
		END
		ELSE
		BEGIN
			INSERT INTO  #recordFound2 (ProductID,ProductCategoryId , rowNumber )
			SELECT c.Id, rf.ProductCategoryId, 	ROW_NUMBER() OVER (ORDER BY c.Name) AS rowNumber 
				FROM #recordFound rf
				INNER join Products c
					ON rf.ProductID=c.Id
					where  c.isActive=1
			order by rowNumber
		END
		 
		 
		 		
		IF EXISTS(select name from tempdb..sysobjects  where name like '#recordFound') drop table #recordFound
      
	  
	  
	    SELECT DISTINCT p.*
			 FROM #recordFound2 rf
				INNER join ProductCategories p ON rf.ProductCategoryId=p.Id
			 WHERE rf.rowNumber BETWEEN @skip+1 AND @skip+@top
		
	  
	    SELECT p.*
			 FROM #recordFound2 rf
				INNER join Products p ON rf.ProductId=p.Id
			 WHERE rf.rowNumber BETWEEN @skip+1 AND @skip+@top
		 
		
		DECLARE @RC INT
		SET @RC=@@RowCount
 
		 
			SELECT * 
			FROM
			(	
				SELECT  'Category' as FieldName,c.Name  as ValueFirst,'' as ValueLast
				,t.cnt,10 ord   
				FROM	
				(  
					SELECT ct.[ProductCategoryId],Count(*) cnt
					FROM        dbo.Products ct
					INNER JOIN #recordFound2 rf on rf.ProductId=ct.Id
					where ct.IsActive=1
					group by ct.[ProductCategoryId]
				) t inner join [dbo].[ProductCategories] c
				ON t.[ProductCategoryId] = c.id 
				where c.IsActive=1
			    --group by c.Category
					
			 
			 
	 		 
			 UNION
  
 
		 
		 SELECT  ct.Name as FieldName,ct.Value as ValueFirst,'' as ValueLast, Count(*) cnt, 60 ord 
					FROM        [dbo].[ProductSpecifications] ct
					INNER JOIN #recordFound2 rf on rf.ProductId=ct.ProductId
					where ct.value <> ''  
				
					group by ct.Name,ct.Value
		--			 	order by ct.Name

	) AS E ORDER BY ord
 


		
		SELECT COUNT(*) RecordsTotal, @skip+1 RecordFirst,  @skip+@top RecordLast, @RC RecordCount
		FROM #recordFound2 
		
		

 	/*
IF EXISTS(select name from tempdb..sysobjects  where name like '#recordFound%') drop table #recordFound
 IF EXISTS(select name from tempdb..sysobjects  where name like '#recordFound2') drop table #recordFound2
*/
 
END

GO
/****** Object:  StoredProcedure [dbo].[GetImages]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetImages] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --- Entity main images
SELECT top(0)  t.[Name] CategoryName
       ,p.[Name] 
       , p.[ImagePath]
       , p.[ImagePath2]
       ,'ProductMainImage' EntityImageType
  FROM [TestEY_Horizon].[dbo].[Products] p INNER JOIN
  [TestEY_Horizon].[dbo].[Catalog]  t
			ON p.[Catalog_ID]=t.[ID]
				 
  where p.ImagePath<>''


  -- Entity Media images and files
  SELECT [File_Type]
      ,[Modul_Name]
      ,[Mod]
      ,p.Name
	  ,t.[Name] CategoryName
      ,[File_Path]
      ,[File_Desc]
      ,[File_Name]
      ,[File_Format]
  FROM [TestEY_Horizon].[dbo].[Media] m 
  INNER JOIN [TestEY_Horizon].[dbo].[Products] p 
  ON m.Modul_ID = p.Products_ID
   INNER JOIN  [TestEY_Horizon].[dbo].[Catalog]  t
			ON p.[Catalog_ID]=t.[ID]


END

GO
/****** Object:  StoredProcedure [dbo].[GetSubscribersStats]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
   exec dbo.GetSubscribersStats @BrowserNotificationId=5

*/
CREATE PROCEDURE [dbo].[GetSubscribersStats]
     @BrowserNotificationId int= null 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT n.[Id]
				  ,[Name]
		  ,[NotificationType]
		  ,[CreatedDate] [DateSent]
		  ,stats.NotTracked
	      ,stats.SWUpdated
		  ,stats.DebuggingSingal
		  ,stats.SWUnregister
		  ,stats.Delivered
		  ,stats.Clicked
	FROM [dbo].[BrowserNotifications] n
		   INNER JOIN 
				  (SELECT [BrowserNotificationId], 
				  ISNULL([-1],0) NotTracked,
				  ISNULL([4],0) DebuggingSingal,  
				  ISNULL([1],0) SWUpdated, 
				  ISNULL([2],0) SWUnregister , 
				  ISNULL([8],0) Delivered, 
				  ISNULL([16],0) Clicked
						 FROM
						 (
						 SELECT  [BrowserNotificationId]
								 ,[NotificationStatus]
									  ,COUNT(*) Cnt
						   FROM [dbo].[BrowserNotificationFeedBacks]
						   GROUP BY [BrowserNotificationId],[NotificationStatus]
						   ) t
						 PIVOT
						 (
						 MAX(Cnt)
						 FOR [NotificationStatus] IN ([-1], [1], [2], [4], [8],[16])
						 ) AS PivotTable
						 ) stats
				  ON stats.[BrowserNotificationId]=n.[Id]
				  where n.[Id]=ISNULL(@BrowserNotificationId,n.[Id])
	ORDER BY [CreatedDate] desc 
 



END

GO
/****** Object:  StoredProcedure [dbo].[InsertProductFiles]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertProductFiles] 
	 @Lang int,
	 @Name nvarchar(255),
	 @fileStorageId int,
	 @MainProductImageId int = 1,
	 @fileName nvarchar(255),
	 @CategoryName nvarchar(255),
	 @SkipMainImage bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
 declare @productId int
select @productId= ISNULL(p.Id,-1) from Products p INNER JOIN [dbo].[ProductCategories] pc ON p.[ProductCategoryId] = pc.Id where p.Name=@name and pc.Name=@CategoryName

  IF @SkipMainImage = 0
  BEGIN
  	update p set p.MainImageId=@MainProductImageId from Products p where p.Id=@productId
  END


    -- Insert statements for procedure here
	
INSERT INTO [dbo].[ProductFiles]
           ([ProductId]
           ,[FileStorageId]
           ,[Name]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[EntityHash]
           ,[Lang])

		   VALUES
           (
         @productId,
		 @FileStorageId,
		 @fileName,getdate(),getdate(),1,1,'',@lang
		 )

		 select @productId productId

END

GO
/****** Object:  StoredProcedure [dbo].[MathCalculation]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MathCalculation]
(
    @Dividend INT, 
    @Divisor INT
)
AS
BEGIN
SET NOCOUNT ON;
    BEGIN TRY
      SELECT @Dividend/@Divisor as Quotient;
    END TRY
    BEGIN CATCH
     PRINT Error_message();
	  EXEC [dbo].[db_error_Learning_Insert_ErrorLog] --To log Stored procedure errors
    END CATCH
SET NOCOUNT OFF;
END  

GO
/****** Object:  StoredProcedure [dbo].[Migrate]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Migrate]
	 @Lang int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec MigrateMenuData @Lang
	exec [dbo].[MigrateProductCategoryData] @Lang
    exec MigrateProductData @Lang

	delete from  [dbo].[Subscribers]
	INSERT INTO [dbo].[Subscribers]
           ([Name]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[Email]
           ,[EntityHash]
           ,[Lang]
           ,[Note])
	SELECT case when  [Name]<>[Email]  THEN [Name] ELSE '' END
	,getdate()
	,getdate()
	,1
	,1
      ,[Email]
    ,''
	,@Lang
	,''
  FROM [TestEY_Horizon].[dbo].[EmailList]
  
    update [dbo].[ProductCategories] set [TemplateId]=1
END

GO
/****** Object:  StoredProcedure [dbo].[MigrateChildMenuData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[MigrateChildMenuData]
      @ParentId int=0,
	   @Lang int = 1 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @ParentId <> 0
	BEGIN
			declare @parentId2 int=0

			select @parentId2 = m.Id from 
			[Menus] m  INNER JOIN 
			[TestEY_Horizon].[dbo].[Navigation] t
			ON Name=[PageName]
				where t.Id=@ParentId

		  
	 			INSERT INTO [dbo].[Menus]
				 ([ParentId]
				   ,[Name]
				   ,[CreatedDate]
				   ,[UpdatedDate]
				   ,[IsActive]
				   ,[Position]
				   ,[Description]
				   ,[ImageState]
				   ,[MainPage]
				   ,[LinkIsActive]
				   ,[Link]
				   ,[Static]
				   ,[MainImageId]
				   ,[MenuLink]
				   ,[PageTheme]
				   ,[Lang]
				   ,[EntityHash]
				   ,[MetaKeywords])

     SELECT   @parentId2,
				t.[PageName],getdate(),getdate(),1,t.[NavigationOrdering],t.[PageDescription],0,0,0,'',0,0,'pages-index','T1',@Lang,'',''

			 FROM [TestEY_Horizon].[dbo].[Navigation] t
			where ParentId=@ParentId



			 Declare @Keys Table (ID integer Primary Key Not Null)
		 Insert @Keys(ID)
		SELECT  t.ID 
			 FROM [TestEY_Horizon].[dbo].[Navigation] t
			where ParentId=@ParentId
  
  
	 
    
     
			Declare @Key Integer
		   While Exists (Select * From @Keys)
			 Begin
				 Select @Key = Max(ID) From @Keys
				 EXEC MigrateChildMenuData @Key,@Lang
				 print @Key
				 Delete @Keys Where ID = @Key
			 End 

	 END
 



     
END

GO
/****** Object:  StoredProcedure [dbo].[MigrateChildProductCategoryData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[MigrateChildProductCategoryData]
      @ParentId int=0,
	   @Lang int = 1 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @ParentId <> 0
	BEGIN
			declare @parentId2 int=0

			select @parentId2 = m.Id from 
			[ProductCategories] m  INNER JOIN 
			[TestEY_Horizon].[dbo].[Catalog]  t
			ON m.Name=t.[Name]
				where t.Id=@ParentId

		  
	 		INSERT INTO [dbo].[ProductCategories]
           ([ParentId]
           ,[Name]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[Description]
           ,[ImageState]
           ,[MainPage]
           ,[MainImageId]
           ,[Lang]
           ,[TemplateId]
           ,[EntityHash]
           ,[DiscountPercantage]
           ,[MetaKeywords])

     SELECT  @parentId2,t.[Name],getdate(),getdate(),1,t.Ordering,'',0,0,0,@Lang,0,'',0,''

			 FROM [TestEY_Horizon].[dbo].[Catalog] t
			where Parent_Id=@ParentId



			 Declare @Keys Table (ID integer Primary Key Not Null)
		 Insert @Keys(ID)
		SELECT  t.ID 
			 FROM [TestEY_Horizon].[dbo].[Catalog] t
			where Parent_Id=@ParentId
  
  
	 
    
     
			Declare @Key Integer
		   While Exists (Select * From @Keys)
			 Begin
				 Select @Key = Max(ID) From @Keys
				 EXEC MigrateChildProductCategoryData @Key,@Lang
				 print @Key
				 Delete @Keys Where ID = @Key
			 End 

	 END
 



     
END

GO
/****** Object:  StoredProcedure [dbo].[MigrateDataFromOldDatabase]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MigrateDataFromOldDatabase]
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     SELECT TOP 1000 [ID]
      ,[ParentID]
      ,[Static]
      ,[PageName]
      ,[PageTitle]
      ,[PageShortDesc]
      ,[PageDescription]
      ,[PageLayout]
      ,[ImagePath]
      ,[Form]
      ,[Modul]
      ,[Mod]
      ,[NavigationOrdering]
      ,[ImageState]
      ,[State]
      ,[MainPage]
      ,[Lang]
      ,[Link]
      ,[LinkState]
      ,[Created_Date]
      ,[PageMetaKeys]
  FROM [TestEY_Horizon].[dbo].[Navigation]

END

GO
/****** Object:  StoredProcedure [dbo].[MigrateMenuData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[MigrateMenuData]
	 @Lang int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 delete  from [dbo].[Menus]
     
	INSERT INTO [dbo].[Menus]
           ([ParentId]
           ,[Name]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[Description]
           ,[ImageState]
           ,[MainPage]
           ,[LinkIsActive]
           ,[Link]
           ,[Static]
           ,[MainImageId]
           ,[MenuLink]
           ,[PageTheme]
           ,[Lang]
           ,[EntityHash]
           ,[MetaKeywords])

     SELECT  0,t.[PageName],getdate(),getdate(),1,t.[NavigationOrdering],t.[PageDescription],0,0,0,'',0,0,'pages-index','T1',@Lang,'',''
     FROM [TestEY_Horizon].[dbo].[Navigation] t
    where ParentId=0

 

	
 Declare @Keys Table (ID integer Primary Key Not Null)
 Insert @Keys(ID)
SELECT  t.ID 
     FROM [TestEY_Horizon].[dbo].[Navigation] t
    where ParentId=0
  
  
 -- select * from @Keys
    
     
    Declare @Key Integer
   While Exists (Select * From @Keys)
     Begin
         Select @Key = Max(ID) From @Keys
         EXEC MigrateChildMenuData @Key,@Lang
         print @Key
         Delete @Keys Where ID = @Key
     End 
END

GO
/****** Object:  StoredProcedure [dbo].[MigrateProductCategoryData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[MigrateProductCategoryData]
	 @Lang int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 delete  from [dbo].[ProductCategories]
     
	INSERT INTO [dbo].[ProductCategories]
           ([ParentId]
           ,[Name]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[Description]
           ,[ImageState]
           ,[MainPage]
           ,[MainImageId]
           ,[Lang]
           ,[TemplateId]
           ,[EntityHash]
           ,[DiscountPercantage]
           ,[MetaKeywords])

     SELECT  0,t.[Name],getdate(),getdate(),1,t.Ordering,'',0,0,0,@Lang,0,'',0,''
     FROM [TestEY_Horizon].[dbo].[Catalog] t
    where [Parent_ID]=0

	
 Declare @Keys Table (ID integer Primary Key Not Null)
 Insert @Keys(ID)
SELECT  t.ID 
     FROM [TestEY_Horizon].[dbo].[Catalog] t
    where [Parent_ID]=0
  
  
 -- select * from @Keys
    
     
    Declare @Key Integer
   While Exists (Select * From @Keys)
     Begin
         Select @Key = Max(ID) From @Keys
         EXEC [dbo].[MigrateChildProductCategoryData] @Key,@Lang
         print @Key
         Delete @Keys Where ID = @Key
     End 
END

GO
/****** Object:  StoredProcedure [dbo].[MigrateProductData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MigrateProductData]
	@Lang int=1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	delete from [dbo].[Products]

	INSERT INTO [dbo].[Products]
           ([Name]
           ,[NameShort]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive]
           ,[Position]
           ,[Description]
           ,[MainPage]
           ,[ImageState]
           ,[MainImageId]
           ,[ProductCategoryId]
           ,[Price]
           ,[Discount]
           ,[ProductCode]
           ,[Lang]
           ,[VideoUrl]
           ,[EntityHash]
           ,[MetaKeywords])

  SELECT 
      p.[Name]
	  , p.NameExp
	  ,getdate()
	  ,getdate()
	  ,1
	  ,p.Ordering
	  ,p.[Detail]
	  ,0
	  ,0
	  ,0
	,pc.Id
	,Price
	,0
	,Code
	,@Lang
	,''
	,''
	,AnahtarKelimeler
  FROM [TestEY_Horizon].[dbo].[Products] p
  INNER JOIN  [TestEY_Horizon].[dbo].[Catalog] c ON p.[Catalog_ID] = c.Id
   INNER JOIN  [dbo].[ProductCategories]  pc ON c.[Name] = pc.Name

  -- SELECT c.Name
  --    ,p.[Name]
	 -- ,pc.Name
	 -- ,pe.Name
  --    ,[Renk]
  --    ,[KafaSekli]
  --    ,[Hacim]
  --    ,[Cap]
  --    ,[Yukseklik]
  --    ,[Agirlik]
  --    ,[KoliAdedi]
  --    ,[PaketAdedi]
  --    ,[PaletAdedi]
  --    ,[Stok]
  --FROM [TestEY_Horizon].[dbo].[Products] p
  --INNER JOIN  [TestEY_Horizon].[dbo].[Catalog] c ON p.[Catalog_ID] = c.Id
  -- INNER JOIN  [dbo].[ProductCategories]  pc ON c.[Name] = pc.Name
  --   INNER JOIN  [dbo].[Products]  pe ON p.[Name] = pe.Name


	   
--  INSERT INTO [dbo].[ProductSpecifications]
--           ([ProductId]
--           ,[Name]
--           ,[CreatedDate]
--           ,[UpdatedDate]
--           ,[IsActive]
--           ,[Position]
--           ,[Value]
--           ,[Unit]
--           ,[EntityHash]
--           ,[Lang])
--SELECT pe.Id
--      ,'Stok'
--       ,getdate()
--	  ,getdate()
--	  ,1
--	  ,p.Ordering
--	  ,[Stok]
--	  ,''
--	  ,''
--	  ,1
--  FROM [TestEY_Horizon].[dbo].[Products] p
--  INNER JOIN  [TestEY_Horizon].[dbo].[Catalog] c ON p.[Catalog_ID] = c.Id
--   INNER JOIN  [dbo].[ProductCategories]  pc ON c.[Name] = pc.Name
--     INNER JOIN  [dbo].[Products]  pe ON p.[Name] = pe.Name


END

GO
/****** Object:  StoredProcedure [dbo].[pn_GetSubscribersStats]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pn_GetSubscribersStats]
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT n.[Id]
				  ,[Name]
		  ,[NotificationType]
		  ,[CreatedDate] [DateSent]
			 ,stats.NotTracked
			 ,stats.SWUpdated
			 		 ,stats.DebuggingSingal
			  ,stats.SWUnregister
			   ,stats.Delivered
			      ,stats.Clicked
	FROM [dbo].[BrowserNotifications] n
		   INNER JOIN 
				  (SELECT [BrowserNotificationId], ISNULL([-1],0) NotTracked,ISNULL([4],0) DebuggingSingal,  ISNULL([1],0) SWUpdated, ISNULL([2],0) SWUnregister , ISNULL([8],0) Delivered, ISNULL([16],0) Clicked
						 FROM
						 (
						 SELECT  [BrowserNotificationId]
								 ,[NotificationStatus]
									  ,COUNT(*) Cnt
						   FROM [dbo].[BrowserNotificationFeedBacks]
						   GROUP BY [BrowserNotificationId],[NotificationStatus]
						   ) t
						 PIVOT
						 (
						 MAX(Cnt)
						 FOR [NotificationStatus] IN ([-1], [1], [2], [4], [8],[16])
						 ) AS PivotTable
						 ) stats
				  ON stats.[BrowserNotificationId]=n.[Id]

	ORDER BY [CreatedDate] desc 
 



END

GO
/****** Object:  StoredProcedure [dbo].[ReturnAllTableData]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[ReturnAllTableData]
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   declare @tablename varchar(500)
declare @sql varchar(5000)
declare @tableNameSql varchar(500)
declare @idname varchar(50)
declare @tablearchive varchar(500)

--Select all the tables which you want to make in archive
declare tableCursor cursor FAST_FORWARD FOR
SELECT table_name FROM INFORMATION_SCHEMA.TABLES
-- where table_name

--Put your condition, if you want to filter the tables
--like '%TRN_%' and charindex('Archive',table_name) = 0 and charindex('ErrorLog',table_name) = 0

--Open the cursor and iterate till end
OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @tablename WHILE @@FETCH_STATUS = 0
          BEGIN
                  set @tableNameSql = 'select '''+@tablename +''' as TableName'
                  SET @sql = 'select *  from '+ @tablename +''
				   EXEC(@tableNameSql)
                                      EXEC(@sql)
                    
          FETCH NEXT FROM tableCursor INTO @tablename
END
CLOSE tableCursor
DEALLOCATE tableCursor


END

GO
/****** Object:  StoredProcedure [dbo].[test_SearchProducts]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/*

  DECLARE @filter as ei_tpt_Filter
 
 -- INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('company','raymarine','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Included Qty x Type','USB adapter - 5 pin Micro-USB Type B ( female ) - Apple Dock connector ( male ) USB cable - 5 pin Micro-USB Type B ( male ) - 4 pin USB Type A ( male )','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Warranty','1 Year','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Part Numbers','CW13632','') 
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast) VALUES ('Depth','1.5','')
  --INSERT INTO @filter (FieldName, ValueFirst, ValueLast)  VALUES ('Low Voltage Power','20','')
 

exec [dbo].[test_SearchProducts] @search = '', @top = 100, @skip = 0, @filter= @filter



 
 select * from  dbo.Products where ProductID = 5521
 
 
 select * from   dbo.ProductsSpecValues psv
	    
			WHERE  ProductSpecID=152 AND ValueString= 'USB adapter - 5 pin Micro-USB Type B ( female ) - Apple Dock connector ( male ) USB cable - 5 pin Micro-USB Type B ( male ) - 4 pin USB Type A ( male )'
 

*/
CREATE PROCEDURE [dbo].[test_SearchProducts]
	@search nvarchar(200)='',
	@top int=20,
	@skip int=0,
	@language int=1,
	@filter AS dbo.ei_tpt_Filter Readonly 
AS
BEGIN

	SET NOCOUNT ON;
	
SELECT p.*
FROM dbo.Products as p
 where 	p.IsActive=1 and p.Lang = @language
 
SELECT p.*
FROM dbo.ProductCategories as p
 where 	p.IsActive=1 and p.Lang = @language
 

END

GO
/****** Object:  StoredProcedure [dbo].[updateAllLang]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateAllLang] 
	@Lang Int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update  [dbo].[Menus]  set Lang=1

Update  Products  set Lang=1

Update  ProductSpecifications  set Lang=1

Update  ProductFiles  set Lang=1

Update  Products  set Lang=1

Update  ProductCategories  set Lang=1




Update  FileStorages  set Lang=1


Update  ListItems  set Lang=1

Update  Lists  set Lang=1

Update  MainPageImages  set Lang=1

Update  MenuFiles set Lang=1

Update  Menus  set Lang=1





--Update  Settings
Update  Stories  set Lang=1

Update  StoryCategories  set Lang=1

Update  StoryFiles  set Lang=1


Update  Subscribers  set Lang=1

Update  TagCategories  set Lang=1

Update  Tags set Lang=1

Update  MailTemplates set Lang=1

END
GO
/****** Object:  StoredProcedure [eimeceroot].[DeleteProduct]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [eimeceroot].[DeleteProduct] 
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	  delete from [dbo].[ProductSpecifications] where Id =@Id
	    delete from [dbo].[ProductFiles] where Id =@Id
		  delete from [dbo].[ProductTags] where Id =@Id
		    
  delete from [dbo].[Products] where Id =@Id

END
GO
/****** Object:  StoredProcedure [eimeceroot].[DeleteProducts]    Script Date: 4/28/2022 11:44:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [eimeceroot].[DeleteProducts] 
 
AS
BEGIN
	
   Declare @Keys Table (Id integer Primary Key Not Null)
   Insert @Keys(Id)
select top 1000 Id  FROM [eimece].[dbo].[Products] where [ProductCategoryId] IN (
SELECT [ProductCategoryId]
  FROM [eimece].[dbo].[Products]
  group by [ProductCategoryId]
  )
  order by NEWID()
   -- -------------------------------------------
   Declare @Id Integer
   While Exists (Select * From @Keys)
     Begin
         Select @Id = Max(Id) From @Keys
         EXEC DeleteProduct @Id
         Delete @Keys Where Id = @Id
     End

END
GO
USE [master]
GO
ALTER DATABASE [eimece] SET  READ_WRITE 
GO
