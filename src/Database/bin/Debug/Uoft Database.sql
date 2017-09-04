﻿/*
Deployment script for UofT

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "UofT"
:setvar DefaultFilePrefix "UofT"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [dbo].[Activity]...';


GO
CREATE TABLE [dbo].[Activity] (
    [ActivityID]   INT      IDENTITY (1, 1) NOT NULL,
    [CourseID]     INT      NOT NULL,
    [ActivityType] CHAR (1) NULL,
    PRIMARY KEY CLUSTERED ([ActivityID] ASC)
);


GO
PRINT N'Creating [dbo].[Building]...';


GO
CREATE TABLE [dbo].[Building] (
    [BuildingID]   INT            IDENTITY (1, 1) NOT NULL,
    [BuildingName] NVARCHAR (MAX) NULL,
    [BuildingCode] NVARCHAR (2)   NULL,
    [Address]      NVARCHAR (MAX) NULL,
    [Latitude]     FLOAT (53)     NULL,
    [Longitude]    FLOAT (53)     NULL,
    PRIMARY KEY CLUSTERED ([BuildingID] ASC)
);


GO
PRINT N'Creating [dbo].[BuildingDistances]...';


GO
CREATE TABLE [dbo].[BuildingDistances] (
    [BuildingDistanceID] INT        IDENTITY (1, 1) NOT NULL,
    [BuildingID1]        INT        NOT NULL,
    [BuildingID2]        INT        NOT NULL,
    [WalkingDuration]    FLOAT (53) NULL,
    [WalkingDistance]    FLOAT (53) NULL,
    [TransitDuration]    FLOAT (53) NULL,
    [TransitDistance]    FLOAT (53) NULL,
    [CyclingDuration]    FLOAT (53) NULL,
    [CyclingDistance]    FLOAT (53) NULL,
    [DrivingDuration]    FLOAT (53) NULL,
    [DrivingDistance]    FLOAT (53) NULL,
    PRIMARY KEY CLUSTERED ([BuildingDistanceID] ASC)
);


GO
PRINT N'Creating [dbo].[Course]...';


GO
CREATE TABLE [dbo].[Course] (
    [CourseID]    INT            IDENTITY (1, 1) NOT NULL,
    [Code]        NVARCHAR (10)  NULL,
    [Campus]      NVARCHAR (MAX) NULL,
    [Term]        CHAR (1)       NULL,
    [Title]       NVARCHAR (MAX) NULL,
    [Description] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CourseID] ASC)
);


GO
PRINT N'Creating [dbo].[Instructor]...';


GO
CREATE TABLE [dbo].[Instructor] (
    [InstructorID] INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [Rating]       FLOAT (53)     NULL,
    PRIMARY KEY CLUSTERED ([InstructorID] ASC)
);


GO
PRINT N'Creating [dbo].[InstructorToActivity]...';


GO
CREATE TABLE [dbo].[InstructorToActivity] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [InstructorID] INT NOT NULL,
    [SectionID]    INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[Section]...';


GO
CREATE TABLE [dbo].[Section] (
    [SectionID]   INT            IDENTITY (1, 1) NOT NULL,
    [ActivityID]  INT            NOT NULL,
    [SectionCode] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([SectionID] ASC)
);


GO
PRINT N'Creating [dbo].[Session]...';


GO
CREATE TABLE [dbo].[Session] (
    [SessionID]         INT            IDENTITY (1, 1) NOT NULL,
    [SectionID]         INT            NOT NULL,
    [Fall_BuildingID]   INT            NULL,
    [Fall_RoomNumber]   NVARCHAR (MAX) NULL,
    [Winter_BuildingID] INT            NULL,
    [Winter_RoomNumber] NVARCHAR (MAX) NULL,
    [StartTime]         FLOAT (53)     NULL,
    [EndTime]           FLOAT (53)     NULL,
    PRIMARY KEY CLUSTERED ([SessionID] ASC)
);


GO
PRINT N'Creating unnamed constraint on [dbo].[Activity]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course] ([CourseID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[BuildingDistances]...';


GO
ALTER TABLE [dbo].[BuildingDistances]
    ADD FOREIGN KEY ([BuildingID1]) REFERENCES [dbo].[Building] ([BuildingID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[BuildingDistances]...';


GO
ALTER TABLE [dbo].[BuildingDistances]
    ADD FOREIGN KEY ([BuildingID2]) REFERENCES [dbo].[Building] ([BuildingID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[InstructorToActivity]...';


GO
ALTER TABLE [dbo].[InstructorToActivity]
    ADD FOREIGN KEY ([InstructorID]) REFERENCES [dbo].[Instructor] ([InstructorID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[InstructorToActivity]...';


GO
ALTER TABLE [dbo].[InstructorToActivity]
    ADD FOREIGN KEY ([SectionID]) REFERENCES [dbo].[Section] ([SectionID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Section]...';


GO
ALTER TABLE [dbo].[Section]
    ADD FOREIGN KEY ([ActivityID]) REFERENCES [dbo].[Activity] ([ActivityID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Session]...';


GO
ALTER TABLE [dbo].[Session]
    ADD FOREIGN KEY ([SectionID]) REFERENCES [dbo].[Section] ([SectionID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Session]...';


GO
ALTER TABLE [dbo].[Session]
    ADD FOREIGN KEY ([Fall_BuildingID]) REFERENCES [dbo].[Building] ([BuildingID]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Session]...';


GO
ALTER TABLE [dbo].[Session]
    ADD FOREIGN KEY ([Winter_BuildingID]) REFERENCES [dbo].[Building] ([BuildingID]);


GO
PRINT N'Creating [dbo].[Activity].[ActivityType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = Lecture, 1 = Tutorial, 2 = Practical', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'ActivityType';


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '796a5d3e-7dfb-40f5-b97a-7af38c994e1b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('796a5d3e-7dfb-40f5-b97a-7af38c994e1b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '05cd580f-7f48-4d43-9e14-ea101fd722c9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('05cd580f-7f48-4d43-9e14-ea101fd722c9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7ecd557f-7792-4f21-89f8-75012e37e7c2')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7ecd557f-7792-4f21-89f8-75012e37e7c2')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '69571e54-3d7f-4cd5-8d03-381ee0d40df9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('69571e54-3d7f-4cd5-8d03-381ee0d40df9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ad460afa-c783-4458-9eb5-326180cdaf4a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ad460afa-c783-4458-9eb5-326180cdaf4a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '961e8927-cf9d-4970-916f-f16d0a25497b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('961e8927-cf9d-4970-916f-f16d0a25497b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5bc0bcfd-d0f3-4e5b-bad2-07609b4fddbe')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5bc0bcfd-d0f3-4e5b-bad2-07609b4fddbe')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bcb58afb-2982-4b4f-976f-da382d4eb9da')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bcb58afb-2982-4b4f-976f-da382d4eb9da')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2d373f26-9234-4ac8-8b5c-c99e01077031')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2d373f26-9234-4ac8-8b5c-c99e01077031')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '65a76173-a984-4174-882e-8b00d82cb417')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('65a76173-a984-4174-882e-8b00d82cb417')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '78f29ace-add6-4d84-8424-ec8525763003')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('78f29ace-add6-4d84-8424-ec8525763003')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0f529091-5b27-42fa-8011-d3c7b2c57139')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0f529091-5b27-42fa-8011-d3c7b2c57139')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5817a476-3b74-489b-889f-1bee188a6410')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5817a476-3b74-489b-889f-1bee188a6410')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7391642b-b0ec-4bba-bfd3-d03ea2c386a8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7391642b-b0ec-4bba-bfd3-d03ea2c386a8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cd612317-a957-4ad4-8f09-fed3960d8323')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cd612317-a957-4ad4-8f09-fed3960d8323')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2ea5c95e-11b4-46e1-a491-6ec715768ba3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2ea5c95e-11b4-46e1-a491-6ec715768ba3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cff15964-c44c-413e-9bd7-452af8ef43ce')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cff15964-c44c-413e-9bd7-452af8ef43ce')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2e4375e0-b1fc-464e-b215-0ea306c79833')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2e4375e0-b1fc-464e-b215-0ea306c79833')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b139aeba-73b0-4f42-aebf-a26263db00c0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b139aeba-73b0-4f42-aebf-a26263db00c0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e945f29e-429b-4155-924c-81005400e0e2')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e945f29e-429b-4155-924c-81005400e0e2')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '64942588-9b66-4bf3-a46a-7623b537f62a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('64942588-9b66-4bf3-a46a-7623b537f62a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7fd2f2ca-a9ef-4cea-92d8-98ce10bcc770')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7fd2f2ca-a9ef-4cea-92d8-98ce10bcc770')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '102102eb-013b-4e63-86f8-dc3ad7a8f685')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('102102eb-013b-4e63-86f8-dc3ad7a8f685')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '356e46ce-52e6-449b-b9f0-c7a3c5d5d4be')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('356e46ce-52e6-449b-b9f0-c7a3c5d5d4be')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '37114e32-bc0a-4c77-8d90-90ca4d447590')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('37114e32-bc0a-4c77-8d90-90ca4d447590')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '3d0ac563-0830-4198-9677-540e7c2e8901')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('3d0ac563-0830-4198-9677-540e7c2e8901')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '62d1a6a3-b6c2-495b-babd-a67101e6fcbb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('62d1a6a3-b6c2-495b-babd-a67101e6fcbb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '8289d1d8-d47b-4445-897f-7198580dc11d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('8289d1d8-d47b-4445-897f-7198580dc11d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '49bf84fc-3a50-48e0-bfa9-1942f89c1aaf')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('49bf84fc-3a50-48e0-bfa9-1942f89c1aaf')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '03ddf1b1-6170-4436-a6e1-82dc1d0dd872')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('03ddf1b1-6170-4436-a6e1-82dc1d0dd872')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bcaebdf5-8440-4358-85ac-eaa9f8b4398f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bcaebdf5-8440-4358-85ac-eaa9f8b4398f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c40eac7c-6863-4bfe-bfed-f78a8c4c18d0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c40eac7c-6863-4bfe-bfed-f78a8c4c18d0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '9efb82ca-034a-41ab-a921-c25a875b9466')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('9efb82ca-034a-41ab-a921-c25a875b9466')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b3dc40f4-9ef5-495a-b3ae-39dd722bf7c0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b3dc40f4-9ef5-495a-b3ae-39dd722bf7c0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fff4cf0e-0560-4be4-9770-5fc715e13613')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fff4cf0e-0560-4be4-9770-5fc715e13613')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '9a61f2e3-1160-4445-a6e7-66f4f4fef5f3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('9a61f2e3-1160-4445-a6e7-66f4f4fef5f3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '09162a5c-b58f-4ce4-b8b9-948a1715c15f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('09162a5c-b58f-4ce4-b8b9-948a1715c15f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5aa2de70-15f9-45ce-a5db-38ecc9459167')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5aa2de70-15f9-45ce-a5db-38ecc9459167')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '9d58580c-fe44-4883-86aa-090fff1d5faa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('9d58580c-fe44-4883-86aa-090fff1d5faa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2df00f43-e844-4c5e-9089-f25359c78e81')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2df00f43-e844-4c5e-9089-f25359c78e81')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e079dccd-85e0-408c-b66f-257febf9dbda')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e079dccd-85e0-408c-b66f-257febf9dbda')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ce7dc5a9-4293-4fba-8a7e-8bc287623962')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ce7dc5a9-4293-4fba-8a7e-8bc287623962')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd66d028f-dc42-4336-b9d8-1fd2da8bdf1d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d66d028f-dc42-4336-b9d8-1fd2da8bdf1d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ccbb04c5-bcd6-4d56-b9ae-03a37c6c01f8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ccbb04c5-bcd6-4d56-b9ae-03a37c6c01f8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bba069fe-7974-4ac3-bddc-fcfb3a7b09cb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bba069fe-7974-4ac3-bddc-fcfb3a7b09cb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0000660e-c5fc-43f5-9a41-6ce8a54d92fb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0000660e-c5fc-43f5-9a41-6ce8a54d92fb')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
