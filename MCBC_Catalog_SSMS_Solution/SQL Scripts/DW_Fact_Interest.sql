Declare @Businessdate Date = '2019-05-31';

with a as 
(/*AA Arrangements*/
	select 
		a.MIS_DATE,
		A.BRANCH_CO_MNE
		,a.[@ID] as ARRANGEMENT_ID
	from bs.AA_ARRANGEMENT a 
)
,Pn As 
(/*Interest*/
	Select 
		A.Mis_Date
		,A.Id_Comp_1
		,A.Id_Comp_2
		,A.Activity 
		,A.Maxdate 
		,A.Fixed_Rate 
		,A.EFFECTIVE_RATE
	From 
	(
		Select
			I.Mis_Date
			,I.Id_Comp_1 
			,I.Id_Comp_2 
			,I.Id_Comp_3
			,i.fixed_rate
			,i.EFFECTIVE_RATE
			,I.Activity
			,Max(I.Id_Comp_3) Over (Partition By Concat(I.Id_Comp_1,I.Id_Comp_2) ) As Maxdate

		From
			Bs.Aa_Arr_Interest I
		Where 
			Mis_Date = @Businessdate
		Group By
		I.Mis_Date
		,I.Id_Comp_1 
		,I.Id_Comp_2 
		,I.Id_Comp_3
		,I.Fixed_Rate
		,i.EFFECTIVE_RATE
		,I.Activity
	) A
	Where A.Id_Comp_3 = A.Maxdate
)

-----------MAIN SELECT-------------
select 
	account.MIS_DATE,
	ACCOUNT.BRANCH_CO_MNE
	,account.ARRANGEMENT_ID as ACCOUNT_CONTRACT_ID
	,account.INTEREST_RATE
	,account.PENALTY_RATE
	,account.EFFECTIVE_RATE
from
(
	select 
		a.MIS_DATE
		,A.BRANCH_CO_MNE
		,a.ARRANGEMENT_ID
		,pn01.FIXED_RATE as INTEREST_RATE
		,pn02.FIXED_RATE as PENALTY_RATE
		,pn01.EFFECTIVE_RATE
	from a -- arrangements
		left join pn pn01 on pn01.MIS_DATE = a.MIS_DATE and pn01.ID_COMP_1 = a.ARRANGEMENT_ID and pn01.ID_COMP_2 = 'principalint'
		left join pn pn02 on pn02.MIS_DATE = a.MIS_DATE and pn02.ID_COMP_1 = a.ARRANGEMENT_ID and pn02.ID_COMP_2 = 'penaltyint'

)account

where account.MIS_DATE = @Businessdate

