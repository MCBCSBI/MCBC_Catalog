use insightlanding_sey
go

Declare @BusinessDate Date = '2019-09-30'

select 
	MIS_DATE,
	replace([@ID],'*','') as [@ID] 
	,CURRENCY_CODE
	,CURRENCY_MARKET
	--,NUMERIC_CCY_CODE
	,CCY_NAME
	,INTEREST_DAY_BASIS
	,COUNTRY_CODE
	,[Hash_SCD2]=
	isnull(
	convert(char(66),HASHBYTES('SHA2_256',concat(MIS_DATE,
	[@ID]
	,CURRENCY_CODE
	,CURRENCY_MARKET
	--,NUMERIC_CCY_CODE
	,CCY_NAME
	,INTEREST_DAY_BASIS
	,COUNTRY_CODE)),1),0)

from bnk_CURRENCY
where MIS_DATE=@BusinessDate
