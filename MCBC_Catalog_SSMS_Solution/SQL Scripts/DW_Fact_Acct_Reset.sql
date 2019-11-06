Declare @BusinessDate Date = '2019-06-06'; --?

select DISTINCT 
	 ISNULL(A.RESET_DATE, A.MIS_DATE) MIS_DATE
	,A.BRANCH_CO_MNE
	,A.[@ID] as ACCOUNT_NUMBER
	,ISNULL(A.RESET_DATE, A.MIS_DATE) RESET_DATE
	,ISNULL(dbo.fn_getusername(A.INPUTTER), '-1') as INPUTTER
	,ISNULL(dbo.fn_getusername(A.AUTHORISER), '-1') as AUTHORISER
	,Cast('20' + Left(CAST(A.Date_Time as NVARCHAR(20)), 2) + Substring(CAST(A.Date_Time as NVARCHAR(20)), 3, 2) + Substring(CAST(A.Date_Time as NVARCHAR(20)), 5, 2) As Date) as DateAuthorized
	from 
	bs.ACCT_INACTIVE_RESET A 
	where ISNULL(A.RESET_DATE, A.MIS_DATE) = @BusinessDate