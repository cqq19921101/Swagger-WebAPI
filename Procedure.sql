USE [HR_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[P_DailyReprot_QueryLvData]    Script Date: 08/13/2019 17:49:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_DailyReprot_QueryLvData]
(
  @P_BU VARCHAR(10),
  @P_ID_DATE VARCHAR(10)
 )
AS
SET NOCOUNT ON
declare @s nvarchar(4000)
DECLARE @tmp  nvarchar(4000)
BEGIN
    
set @s=''
Select @s=@s+','+GRADE+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then LASTMONTH_ACT else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then HC else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then CUM else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then CUM_RATE else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then VOLUNTARY else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then VOLUNTARY_RATE else 0 end)'+','
+quotename(GRADE)+'=sum(case when [GRADE]='+quotename(GRADE,'''')+' then DAILY_LEAVENUM else 0 end)'
from TB_DailyReport_LeaveRate
 WHERE ID_DATE=@P_ID_DATE AND BU=@P_BU GROUP BY GRADE

set @tmp='select DEPT_ID'+@s+' from TB_DailyReport_LeaveRate T1,TB_DailyRerpot_DeptOrder T2 
 WHERE T1.DEPT_ID=T2.Sub_Dept AND ID_DATE='''+@P_ID_DATE+''' AND T1.BU='''+@P_BU+''' group by T1.[DEPT_ID],T2.rowNumber  ORDER BY T2.rowNumber '

EXEC(@tmp)

 
	
	 
	 
END
GO
/****** Object:  StoredProcedure [dbo].[P_DailyReprot_QueryDLBuffer_API]    Script Date: 08/13/2019 17:49:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_DailyReprot_QueryDLBuffer_API]
(
 @P_BU VARCHAR(10),
 @P_DATE VARCHAR(10),
 @P_DEPTID VARCHAR(10)
)
AS
SET NOCOUNT ON
declare @s nvarchar(4000)
IF @P_DEPTID = 'ALL'
 BEGIN
 SELECT SUM(A.DL_DEMAND) AS DL_DEMAND,SUM(A.DL_ACT) AS DL_ACT
 FROM (
 SELECT 
	ORG,DEPT_ID,T1.SUB_DEPT,
	ISNULL(DL_DEMAND,0) AS DL_DEMAND,
	ISNULL(DL_ACT,0) AS DL_ACT
	FROM TB_DailyReport_MasterInfo T1,
	TB_DailyRerpot_DeptOrder T2
	WHERE T1.SUB_DEPT=T2.Sub_Dept
	AND T1.BU=@P_BU
	AND ID_DATE=@P_DATE
   ) A
END

ELSE 
BEGIN
 SELECT SUM(A.DL_DEMAND) AS DL_DEMAND,SUM(A.DL_ACT) AS DL_ACT
 FROM (
 SELECT 
	ORG,DEPT_ID,T1.SUB_DEPT,
	ISNULL(DL_DEMAND,0) AS DL_DEMAND,
	ISNULL(DL_ACT,0) AS DL_ACT
	FROM TB_DailyReport_MasterInfo T1,
	TB_DailyRerpot_DeptOrder T2
	WHERE T1.SUB_DEPT=T2.Sub_Dept
	AND T1.BU=@P_BU
	AND ID_DATE=@P_DATE
	AND DEPT_ID = @P_DEPTID
   ) A
END
GO
