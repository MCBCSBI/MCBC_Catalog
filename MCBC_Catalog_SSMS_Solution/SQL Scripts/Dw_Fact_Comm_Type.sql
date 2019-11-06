Declare @BusinessDate Date = '2019-04-08';

with FT as
(
select 
	 FT.PROCESSING_DATE as MIS_DATE
	,FTC.[@ID] as Transaction_ID
	,FTC.Commission_Type
	,substring(FTC.[Commission_Amt],1,3) as Currency
	,substring(FTC.[Commission_Amt],4,15) as FLAT_AMT

 from bs.FUNDS_TRANSFER_Commission_type FTC
 left join bs.FUNDS_TRANSFER FT on FTC.[@ID]=FT.[@ID] and FTC.MIS_DATE=FT.MIS_DATE
 where FT.PROCESSING_DATE=@BusinessDate
)


, ac as
(
select 
	 AC.MIS_DATE
	,AC.[@ID] as Transaction_ID
	,AC.[Charge_code] as Commission_Type
	,AC.[Charge_Currency] as Currency
	,AC.[Charge_Amount] as FLAT_AMT

from bs.AC_CHARGE_REQUEST_Charge_code AC
left join bs.AC_CHARGE_REQUEST ACM on ACM.MIS_DATE=AC.MIS_DATE and ACM.[@ID]=AC.[@ID]
where AC.CHARGE_DATE=@BusinessDate
)

, SO as 
(
select 
	 SO.MIS_DATE
	,SO.[@ID] as Transaction_ID
	,SO.Commission_Type
	,substring(SO.[Commission_Amt],1,3) as Currency
	,substring(SO.[Commission_Amt],4,15) as FLAT_AMT

 from bs.STANDING_ORDER_Commission_type SO
 where SO.MIS_DATE=@BusinessDate
)

,ALLs as
(
Select * from FT
union
Select * from ac
union
Select * from SO
)

Select   DISTINCT
		 ALLs.MIS_DATE
		,Transaction_ID
		,ISNULL(Commission_Type,-1) Commission_Type
		,ISNULL(Alls.Currency,ISnull(Comm_Desc.Currency,'-1')) Currency
		,CAST(ISNULL(Alls.FLAT_AMT,Comm_Desc.Flat_Amt) as Decimal(19,2)) FLAT_AMT
from ALLs
left join bs.FT_COMMISSION_TYPE_Currency Comm_Desc 
on Comm_Desc.[@Id]=ALLs.Commission_type and Comm_Desc.MIS_DATE=Alls.MIS_DATE
where Commission_type is not null
