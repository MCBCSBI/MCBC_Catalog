Declare @BusinessDate Date = '2019-05-31'

select 
	  [@ID] 
	 ,MIS_DATE
	 ,DESCRIPTION
	 ,[Hash_SCD2]=
			isnull(
				convert(char(66),HASHBYTES('SHA2_256',concat([@ID], DESCRIPTION)),1),0)

from [InsightLanding].[BS].CURRENCY_MARKET
where MIS_DATE=@BusinessDate
