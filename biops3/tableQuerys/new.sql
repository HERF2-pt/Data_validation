
    SELECT
    CONVERT(date, Date) as Date,
    CAST(DayOfMonth AS int) as DayOfMonth,
    CAST(DayOfWeekName AS varchar(50)) as DayOfWeekName,
    CONVERT(date, FirstDayOfMonth) as FirstDayOfMonth,
    CONVERT(date, FirstDayOfYear) as FirstDayOfYear,
    CONVERT(date, FiscalFirstDayOfMonth) as FiscalFirstDayOfMonth,
    CONVERT(date, FiscalFirstDayOfMonth_EU) as FiscalFirstDayOfMonth_EU,
    CONVERT(date, FiscalFirstDayOfYear) as FiscalFirstDayOfYear,
    CONVERT(date, FiscalFirstDayOfYear_EU) as FiscalFirstDayOfYear_EU,
    CONVERT(date, FiscalLastDayOfMonth) as FiscalLastDayOfMonth,
    CONVERT(date, FiscalLastDayOfMonth_EU) as FiscalLastDayOfMonth_EU,
    CONVERT(date, FiscalLastDayOfYear) as FiscalLastDayOfYear,
    CONVERT(date, FiscalLastDayOfYear_EU) as FiscalLastDayOfYear_EU,
    CAST(FiscalMonth AS int) as FiscalMonth,
    CAST(FiscalMonth_EU AS int) as FiscalMonth_EU,
    CAST(FiscalMonthName AS varchar(50)) as FiscalMonthName,
    CAST(FiscalMonthName_EU AS varchar(50)) as FiscalMonthName_EU,
    CAST(FiscalQuarter AS int) as FiscalQuarter,
    CAST(FiscalQuarter_EU AS int) as FiscalQuarter_EU,
    CAST(FiscalWeekOfYear AS int) as FiscalWeekOfYear,
    CAST(FiscalWeekOfYear_EU AS int) as FiscalWeekOfYear_EU,
    CAST(FiscalYear AS int) as FiscalYear,
    CAST(FiscalYear_EU AS int) as FiscalYear_EU,
    CAST(FiscalYearName AS varchar(50)) as FiscalYearName,
    CAST(FiscalYearName_EU AS varchar(50)) as FiscalYearName_EU,
    Id,
    CONVERT(date, LastDayOfMonth) as LastDayOfMonth,
    CONVERT(date, LastDayOfYear) as LastDayOfYear,
    CAST(MONTH AS int) as MONTH,
    CAST(MonthName AS varchar(50)) as MonthName,
    CAST(WeekOfYear AS int) as WeekOfYear,
    CAST(Year AS int) as Year
FROM
    RDL00001_EnterpriseDataWarehouse.Shared.DimDate
WHERE
    YEAR(Id) >= YEAR(getdate()) - 5
ORDER BY
    Id


select Id, FirstDayOfMonth,cast(FirstDayOfMonth as Date) as FirstDayOfMonth
,CAST(FirstDayOfMonth AS datetime) AS  second
from RDL00001_EnterpriseDataWarehouse.Shared.DimDate