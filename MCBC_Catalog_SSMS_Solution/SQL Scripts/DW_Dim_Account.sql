--use insightlanding_sey
--go

Declare @Businessdate Date =  '2019-09-30';

with a as (

/*AA Arrangements*/
	select 
		a.MIS_DATE
		,a.[@ID] as ARRANGEMENT_ID
		,left(a.customer,6) as CUSTOMER
		,j.CUSTOMER as JOINT_CUSTOMER
		,ac.CATEGORY as CATEGORY
		,a.LINKED_APPL_ID as ACCOUNT
		,ac.ACCOUNT_TITLE_1
		,d.VALUE_DATE
		,case
			when d.MATURITY_DATE is null
			then d.RENEWAL_DATE
			else d.MATURITY_DATE
		end as MATURITY_DATE
		,d.RENEWAL_DATE
		,a.ARR_STATUS as status
		,a.CURRENCY as CURRENCY_BUY
		,null as CURRENCY_SELL
	from dbo.BNK_AA_ARRANGEMENT a 
		left join /*Joint Customer Query*/
		(
			select 
				c.MIS_DATE
				,c.ID_COMP_1
				,t01.value as CUSTOMER
				--,t01.rw as CUSTOMER_seq
				,t02.value as CUSTOMER_ROLE
				--,t02.rw as CUSTOMER_ROLE_Seq
			from dbo.BNK_AA_ARR_CUSTOMER c
			cross apply
			(
				select
					ROW_NUMBER() over (order by c.CUSTOMER) rw
					,t.value
				from
					string_split(c.customer,nchar(63741)) t
			) t01
			cross apply
			(
				select
					ROW_NUMBER() over (order by c.CUSTOMER_ROLE) rw
					,t.value
				from
					string_split(c.customer_role,nchar(63741)) t
			) t02
			where 
				t01.rw = t02.rw
				and t02.value = 'JOINT.OWNER'
				and c.MIS_DATE = @Businessdate
		) j
			on a.MIS_DATE = j.MIS_DATE and a.[@ID] = j.ID_COMP_1
		left join
		(
			select distinct
				MIS_DATE,
				ID_COMP_1
				,CATEGORY
				,ACCOUNT_TITLE_1
			from dbo.BNK_AA_ARR_ACCOUNT -- take from there instead of ACCOUNT to avoid no match when account record moves to hist
			where MIS_DATE = @Businessdate
		)ac
			on ac.MIS_DATE = a.MIS_DATE and ac.ID_COMP_1 = a.[@ID]
		left join
		(
			select 
				MIS_DATE
				,[@ID]
				,VALUE_DATE
				,MATURITY_DATE
				,RENEWAL_DATE
			from dbo.BNK_AA_ACCOUNT_DETAILS
			where MIS_DATE = @Businessdate
		) d
			on a.MIS_DATE = d.MIS_DATE and a.[@ID] = d.[@ID]
	where a.MIS_DATE = @Businessdate


)

--,Interest_Cashflow as
--(
--	Select 
--		[@ID] as Account_No, 
--		MIS_DATE, 
--		EB.CONTRACT_RATE 
--	from dbo.BNK_EB_CASHFLOW EB
--		where MIS_DATE= @Businessdate
--)


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
			,cast(i.EFFECTIVE_RATE as nvarchar(10)) as EFFECTIVE_RATE
			,I.Activity
			,Max(I.Id_Comp_3) Over (Partition By Concat(I.Id_Comp_1,I.Id_Comp_2) ) As Maxdate

		From
			dbo.BNK_Aa_Arr_Interest I
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

,pur as 
(--------PURPOSE CODE--------
select 
	a.id_comp_1 as arrangement_id
	,a.LOCAL_REF
	,max(a.[@id]) as latest_id
	,convert(
		XML,
		'<localref><attr>'+REPLACE(a.local_ref,nchar(63741),'</attr><attr>')+'</attr></localref>'
		) as localref_xml
from dbo.BNK_AA_ARR_ACCOUNT a

where
	a.MIS_DATE = @Businessdate
group by
	a.LOCAL_REF
	,a.id_comp_1
)
,b as 
(/*Accounts*/
	select 
		ac.MIS_DATE
		,ac.[@ID]
		,ac.CUSTOMER
		,ac.JOINT_HOLDER
		,ac.CATEGORY
		,ac.ACCOUNT_TITLE_1
		,ac.ARRANGEMENT_ID
		,ac.INACTIV_MARKER
		,cast(ac.OPENING_DATE as date) as OPENING_DATE
		,null as MATURITY_DATE
		,null as INTEREST
		,null as PENALTY_INTEREST
		,ac.CURRENCY as CURRENCY_BUY
		,null as CURRENCY_SELL
		,CASE WHEN Overdrawn_Account.ACCOUNT_ID is not null THEN N'Y' ELSE N'N' END as Overdrawn_Flag
	from
		dbo.BNK_ACCOUNT ac
		left outer join
		(
			select ISNULL(l.ACCOUNT,o.[@ID]) ACCOUNT_ID 
			from 
				dbo.BNK_ACCOUNT_OVERDRAWN o
			left outer join 
				dbo.BNK_LIMIT l 
					on o.[@ID]=l.[@ID] and o.MIS_DATE=l.MIS_DATE
			inner join 
				dbo.BNK_ACCOUNT a 
					on ISNULL(l.ACCOUNT,o.[@ID])=a.[@ID] and a.MIS_DATE=o.MIS_DATE
			where o.MIS_DATE= @Businessdate
		) Overdrawn_Account 
			on ac.[@ID]=Overdrawn_Account.ACCOUNT_ID
		
	where
		MIS_DATE = @Businessdate
		and
		(
		(ac.CATEGORY >2000 and ac.CATEGORY <=2999)--vostro
		or (ac.CATEGORY>5000 and ac.CATEGORY <=5999)--Nostro
		or (ac.CATEGORY >=10000)-- Internal Accounts
		)
)
,m as 
(/*MD DEALS*/
	Select 
		Md.[Mis_Date]
		,md.[@Id]
		,md.Customer 
		,null as JOINT_CUSTOMER
		,md.Category 
		,null as Linked_Account
		,nuLL As Account_Title_1
		,md.DEAL_DATE
		,cast(md.MATURITY_DATE as date) as MATURIY_DATE
		,null as interest
		,null as penalty_interest
		,md.CURRENCY as CURRENCY_BUY
		,null as CURRENCY_SELL
	From 
		dbo.BNK_MD_DEAL md
)
,lc as
(/*Letter of Credit*/
	Select 
		lc.MIS_DATE
		,lc.[@ID]
		,lc.LC_TYPE
		,isnull(lc.BENEFICIARY_CUSTNO,lc.APPLICANT_CUSTNO) as CUSTOMER
		,null as JOINT_CUSTOMER
		,lc.CATEGORY_CODE
		,null as ACCOUNT
		,null as ACCOUNT_TITLE
		,lc.ISSUE_DATE
		,lc.EXPIRY_DATE
		,null as INTEREST
		,null as PENALTY_INTEREST
		,lc.LC_CURRENCY as CURRENCY_BUY
		,NULL as CURRENCY_SELL
	From
		dbo.BNK_LETTER_OF_CREDIT LC
)
--,s as
--(/*SECURITIES*/
--	Select 
--		P.Mis_Date
--		,p.[@ID] As ID
--		,A.Customer_Number
--		,null as joint_customer
--		,A.Category
--		,null as linked_account
--		,Null as account_title
--		,a.START_DATE
--		,a.CLOSURE_DATE
--		,null as interest
--		,null as penalty_interest
--		,s.EFFECTIVE_RATE
--		,A.REFERENCE_CURRENCY as CURRENCY_BUY
--		,NULL as CURRENCY_SELL
--	From 
--		dbo.BNK_SECURITY_POSITION P
--		Left Join dbo.BNK_SEC_ACC_MASTER A  
--			On P.Tradingunitid = A.[@Id] And P.Mis_Date = A.Mis_Date
--		Left Join dbo.BNK_SECURITY_MASTER S 
--			On P.Issuanceid = S.[@Id] And P.Mis_Date = S.Mis_Date
--	where p.MIS_DATE = @Businessdate
--)
,f as 
(/*FOREX*/
	Select 
		F.Mis_Date
		,F.[@Id] 
		,F.Counterparty
		,F.Category_Code 
		,null as account
		,null As Account_Title_1
		,Null As Joint_Holder
		,Null As Arrangement_Id
		,f.VALUE_DATE_BUY
		,f.DEL_DATE_BUY
		,null as interest
		,null as penalty_interest
		,F.CURRENCY_BOUGHT as CURRENCY_BUY
		,F.CURRENCY_SOLD as CURRENCY_SELL
	From
		dbo.BNK_Forex F
	where f.MIS_DATE = @Businessdate
)

-----------MAIN SELECT-------------
select 
	account.MIS_DATE
	,account.ARRANGEMENT_ID as ACCOUNT_CONTRACT_ID
	--,account.Purpose_Code
	--,account.Sub_Purpose_Code
	--,account.LC_Type
	--,account.CUSTOMER
	--,account.JOINT_CUSTOMER
	--,account.CATEGORY
	--,cat.DESCRIPTION as Product_Desc
	,account.ACCOUNT as LINKED_ACCOUNT
	--,l.[@ID] as LIMIT_REF
	--,l.Parent_Limit as Parent_Limit_Ref
	--,l.LIMIT_EXPIRY_DATE
	--,l.LIMIT_REVIEW_DATE
	,cast(account.ACCOUNT_TITLE_1 as nvarchar(50)) as ACCOUNT_TITLE_1
	,account.VALUE_DATE
	,account.MATURITY_DATE
	,account.RENEWAL_DATE
	,case 
		when (account.MATURITY_DATE is null) or DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 31
			then '1. 1-31 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 180
			then '2. 32-180 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 365
			then '3. 181-365 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 1095
			then '4. 366-1095 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 1825
			then N'5. 1096-1825 days'
		else '6. > 1825 days'
	end MATURITY_BUCKET
	,CASE WHEN c.ACCT_CLOSE_DATE is not null then CAST(c.ACCT_CLOSE_DATE as DATE)  END ACCT_CLOSE_DATE
	,account.status
	,account.INTEREST_RATE
	--,account.PENALTY_RATE
	--,account.EFFECTIVE_RATE
	--,account.CURRENCY_BUY
	--,account.CURRENCY_SELL
	--,account.INACTIV_MARKER
	--,ISNULL(account.Overdrawn_Flag,'N') Overdrawn_Flag
	,[Hash_SCD2]=
				isnull(
					convert(char(66),HASHBYTES('SHA2_256',concat(
				account.ARRANGEMENT_ID
				--,account.Purpose_Code
				--,account.Sub_Purpose_Code
				--,account.LC_Type
				--,account.CUSTOMER
				--,account.JOINT_CUSTOMER
				--,account.CATEGORY
				--,cat.DESCRIPTION
				,account.ACCOUNT
				--,l.[@ID]
				--,l.Parent_Limit
				--,l.LIMIT_EXPIRY_DATE
				--,l.LIMIT_REVIEW_DATE
				,account.ACCOUNT_TITLE_1
				,account.VALUE_DATE
				,account.MATURITY_DATE
				,account.RENEWAL_DATE
				,case 
		when (account.MATURITY_DATE is null) or DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 31
			then '1. 1-31 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 180
			then '2. 32-180 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 365
			then '3. 181-365 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 1095
			then '4. 366-1095 days'
		when DATEDIFF(d,account.VALUE_DATE,account.MATURITY_DATE) <= 1825
			then N'5. 1096-1825 days'
		else '6. > 1825 days'
	end
				,c.ACCT_CLOSE_DATE
				,account.status
				,account.INTEREST_RATE
				--,account.PENALTY_RATE
				--,account.EFFECTIVE_RATE
				--,account.CURRENCY_BUY
				--,account.CURRENCY_SELL
				--,account.INACTIV_MARKER
				--,account.Overdrawn_Flag
				)),1),0) 

from
(
	select 
		a.MIS_DATE
		,a.ARRANGEMENT_ID
		,/*p.DESCRIPTION*/ null as Purpose_Code
		,/*pp.DESCRIPTION*/ null as Sub_Purpose_Code  
		,null as LC_Type
		,a.CUSTOMER
		,a.JOINT_CUSTOMER
		,a.CATEGORY
		,a.ACCOUNT
		,a.ACCOUNT_TITLE_1
		,convert(date,a.VALUE_DATE,112) as VALUE_DATE
		,a.MATURITY_DATE
		,a.RENEWAL_DATE
		,a.status
		,/*Interest_Cashflow.CONTRACT_RATE*/ pn01.EFFECTIVE_RATE as INTEREST_RATE
		--,pn02.FIXED_RATE as PENALTY_RATE
		--,pn01.EFFECTIVE_RATE
		,a.CURRENCY_BUY
		,a.CURRENCY_SELL
		,null as INACTIV_MARKER
		,null as Overdrawn_Flag
	from a -- arrangements
		left join pn pn01 on pn01.MIS_DATE = a.MIS_DATE and pn01.ID_COMP_1 = a.ARRANGEMENT_ID and pn01.ID_COMP_2 = 'principalint'
		--left join pn pn02 on pn02.MIS_DATE = a.MIS_DATE and pn02.ID_COMP_1 = a.ARRANGEMENT_ID and pn02.ID_COMP_2 = 'penaltyint'
		left join pur on pur.arrangement_id = a.ARRANGEMENT_ID
		--left join dbo.BNK_PURPOSE_CODE_ESB p on p.[@ID] = pur.localref_xml.value('/localref[1]/attr[1]','nvarchar(5)')
		--left join dbo.BNK_SUB_PURPOSE_CODE_ESB pp on pp.[@ID]  = pur.localref_xml.value('/localref[1]/attr[2]','nvarchar(5)')
		--left join Interest_Cashflow on Interest_Cashflow.Account_No=a.ACCOUNT and Interest_Cashflow.MIS_DATE=a.MIS_DATE

	union

	select
		b.MIS_DATE
		,b.[@ID]
		,null as purpose_code
		,null as sub_purpose_code
		,null as LC_Type
		,b.CUSTOMER
		,b.JOINT_HOLDER
		,b.CATEGORY
		,b.[@ID]
		,b.ACCOUNT_TITLE_1
		,b.OPENING_DATE
		,b.MATURITY_DATE
		,null
		,null
		,b.INTEREST
		--,b.PENALTY_INTEREST
		--,null as EFFECTIVE_RATE
		,b.CURRENCY_BUY
		,b.CURRENCY_SELL
		,b.INACTIV_MARKER
		,b.Overdrawn_Flag
	from b -- accounts

	union 

	Select 
		m.MIS_DATE
		,m.[@ID]
		,null as purpose_code
		,null as sub_purpose_code
		,null as LC_Type
		,m.CUSTOMER 
		,null as JOINT_CUSTOMER
		,m.CATEGORY
		,m.[@ID]
		,m.Account_Title_1
		,m.DEAL_DATE
		,m.MATURIY_DATE
		,null
		,null
		,m.interest
		--,m.penalty_interest
		--,null as EFFECTIVE_RATE
		,m.CURRENCY_BUY
		,m.CURRENCY_SELL
		,null as INACTIV_MARKER
		,null as Overdrawn_Flag
	From m --md deals

	union

	select
		lc.MIS_DATE
		,lc.[@ID]
		,null as purpose_code
		,null as sub_purpose_code
		,lc.LC_TYPE
		,lc.CUSTOMER
		,null as JOINT_CUSTOMER
		,lc.CATEGORY_CODE
		,lc.[@ID]
		,lc.ACCOUNT_TITLE
		,lc.ISSUE_DATE
		,lc.EXPIRY_DATE
		,null
		,null
		,lc.INTEREST
		--,lc.PENALTY_INTEREST
		--,null as EFFECTIVE_RATE
		,lc.CURRENCY_BUY
		,lc.CURRENCY_SELL
		,null as INACTIV_MARKER
		,null as Overdrawn_Flag
	from lc --Letter of credit

	--union

	--select
	--	s.MIS_DATE
	--	,s.ID
	--	,null as purpose_code
	--	,null as sub_purpose_code
	--	,null as LC_Type
	--	,s.CUSTOMER_NUMBER
	--	,s.joint_customer
	--	,s.CATEGORY
	--	,s.ID
	--	,s.account_title
	--	,s.START_DATE
	--	,s.CLOSURE_DATE
	--	,null
	--	,null
	--	,s.interest
	--	--,s.penalty_interest
	--	--,s.EFFECTIVE_RATE
	--	,s.CURRENCY_BUY
	--	,s.CURRENCY_SELL
	--	,null as INACTIV_MARKER
	--	,null as Overdrawn_Flag
	--from s -- securities

	union

	select
		f.MIS_DATE
		,f.[@ID]
		,null as purpose_code
		,null as sub_purpose_code
		,null as LC_Type
		,f.COUNTERPARTY
		,f.Joint_Holder
		,f.CATEGORY_CODE
		,f.[@ID]
		,f.Account_Title_1
		,f.VALUE_DATE_BUY
		,f.DEL_DATE_BUY
		,null
		,null
		,f.interest
		--,f.penalty_interest
		--,null as EFFECTIVE_RATE
		,f.CURRENCY_BUY
		,f.CURRENCY_SELL
		,null as INACTIV_MARKER
		,null as Overdrawn_Flag
	from f -- forex
)account
left join
(
	select distinct -- get closure date for AC ACCOUNTS
		c.[@ID],
		c.ACCT_CLOSE_DATE,
		c.CLOSURE_REASON
	from dbo.BNK_ACCOUNT_CLOSED c
) c
	on account.ACCOUNT = c.[@ID]
left join---join limits
(
	select
		MIS_DATE,
		[@id],
		[PARENT_LINE] as Parent_Limit,
		ACCOUNT,
		EXPIRY_DATE as LIMIT_EXPIRY_DATE,
		CAST(substring(REVIEW_FREQ,1,8) as DATE) LIMIT_REVIEW_DATE
	from
		dbo.BNK_LIMIT
	where PARENT_LINE is not null -- remove parent limit to avoid duplicate entries on join
) l
	on l.MIS_DATE = account.MIS_DATE
		and l.ACCOUNT = account.ACCOUNT

left join dbo.BNK_CATEGORY cat
	on cat.[@ID] = account.CATEGORY

where account.MIS_DATE = @Businessdate

