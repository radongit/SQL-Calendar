USE [OneOff]
GO

/****** Object:  Table [dbo].[Calendar]    Script Date: 8/20/2025 1:31:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Calendar](
	[Cal_ID] [date] NOT NULL,
	[Cal_Year] [smallint] NOT NULL,
	[Cal_MonthNum] [smallint] NOT NULL,
	[Cal_MonthName] [varchar](10) NOT NULL,
	[Cal_WeekNum] [tinyint] NOT NULL,
	[Cal_JSWeekNum] [varchar](8) NULL,
	[Cal_DayofMonth] [tinyint] NOT NULL,
	[Cal_DayofYear] [smallint] NOT NULL,
	[Cal_WeekdayNum] [tinyint] NOT NULL,
	[Cal_WeekdayName] [varchar](10) NOT NULL,
	[Cal_Quarter] [smallint] NOT NULL,
	[Cal_FirstDayofCalMonth] [date] NOT NULL,
	[Cal_LastDayofCalMonth] [date] NOT NULL,
	[Cal_FirstDayofFisMonth] [date] NOT NULL,
	[Cal_LastDayofFisMonth] [date] NOT NULL,
	[Cal_StartTimestamp] [datetime] NOT NULL,
	[Cal_EndTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Calendar] PRIMARY KEY CLUSTERED 
(
	[Cal_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET NOCOUNT ON;
SET DATEFIRST 7; -- Sunday = 1 for weekday numbering

DECLARE @StartDate date = '2020-01-01';
DECLARE @EndDate   date = '2025-12-31';

;WITH d AS (
    SELECT @StartDate AS d
    UNION ALL
    SELECT DATEADD(DAY, 1, d) FROM d WHERE d < @EndDate
)
INSERT INTO [dbo].[Calendar] (
   [Cal_ID],
   [Cal_Year],
   [Cal_MonthNum],
   [Cal_MonthName],
   [Cal_WeekNum],
   [Cal_JSWeekNum],
   [Cal_DayofMonth],
   [Cal_DayofYear],
   [Cal_WeekdayNum],
   [Cal_WeekdayName],
   [Cal_Quarter],
   [Cal_FirstDayofCalMonth],
   [Cal_LastDayofCalMonth],
   [Cal_FirstDayofFisMonth],
   [Cal_LastDayofFisMonth],
   [Cal_StartTimestamp],
   [Cal_EndTimestamp]
)
SELECT
    d.d AS [Cal_ID],
    YEAR(d.d) AS [Cal_Year],
    MONTH(d.d) AS [Cal_MonthNum],
    DATENAME(MONTH, d.d) AS [Cal_MonthName],
    DATEPART(WEEK, d.d) AS [Cal_WeekNum],
    CONCAT(RIGHT('0000' + CAST(YEAR(d.d) AS varchar(4)), 4),
	'-W',
	RIGHT('00' + CAST(DATEPART(WEEK, d.d) AS varchar(2)), 2)) AS [Cal_JSWeekNum],
    DAY(d.d) AS [Cal_DayofMonth],
    DATEPART(DAYOFYEAR, d.d) AS [Cal_DayofYear],
    DATEPART(WEEKDAY, d.d) AS [Cal_WeekdayNum],
    DATENAME(WEEKDAY, d.d) AS [Cal_WeekdayName],
    DATEPART(QUARTER, d.d) AS [Cal_Quarter],
    DATEFROMPARTS(YEAR(d.d), MONTH(d.d), 1) AS [Cal_FirstDayofCalMonth],
    EOMONTH(d.d) AS [Cal_LastDayofCalMonth],
    CASE
        WHEN DAY(d.d) >= 22
            THEN DATEFROMPARTS(YEAR(d.d), MONTH(d.d), 22)
        ELSE DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(d.d), MONTH(d.d), 22))
    END AS [Cal_FirstDayofFisMonth],
    DATEADD(DAY, -1, DATEADD(MONTH, 1,
            CASE
                WHEN DAY(d.d) >= 22
                    THEN DATEFROMPARTS(YEAR(d.d), MONTH(d.d), 22)
                ELSE DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(d.d), MONTH(d.d), 22))
            END)
	) AS [Cal_LastDayofFisMonth],
    CAST(DATEADD(DAY, DATEDIFF(DAY, 0, d.d), 0) AS datetime) AS [Cal_StartTimestamp],
    CAST(DATEADD(MILLISECOND, -3, DATEADD(DAY, 1, DATEADD(DAY, DATEDIFF(DAY, 0, d.d), 0))) AS datetime) AS [Cal_EndTimestamp]
FROM d
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Calendar] c WHERE c.[Cal_ID] = d.d)
OPTION (MAXRECURSION 0);
