--Declare @dt date = ?;
Declare @dt Date =  '2019-09-30';

with a as(
/*ACCOUNTS*/
select 
		ac.MIS_DATE
		,ac.[@ID]
		,ac.ARRANGEMENT_ID as ACCOUNT_CONTRACT_ID
		,ac.ACCOUNT_TITLE_1
		,ac.CATEGORY
		,c.description
		,ac.CURRENCY
		,ac.CUSTOMER
		,ac.JOINT_HOLDER
		,cast(ac.OPENING_DATE as date) as OPENING_DATE
		,ac.INACTIV_MARKER
		--,null as MATURITY_DATE
		--,null as INTEREST
		--,null as PENALTY_INTEREST
		--,CASE WHEN Overdrawn_Account.ACCOUNT_ID is not null THEN N'Y' ELSE N'N' END as Overdrawn_Flag
		,ac.CO_CODE
	from
		dbo.BNK_ACCOUNT ac
		left join bnk_category c
			on c.[@id] = ac.category
			and c.mis_date = ac.mis_date
)

select
	a.mis_date,
	a.[@id]
	,a.account_contract_id
	,a.account_title_1
	,[Hash_SCD2]=isnull(convert(char(66),HASHBYTES('SHA2_256',concat(
					a.[@id]
					,a.account_contract_id
					,a.account_title_1
				)),1),0) 
from a

where 
	a.MIS_DATE = @dt
	--and CATEGORY like '1%'
	--and [@id] = '104078'
	--and len(ac.JOINT_HOLDER) >8
	--and (ac.CUSTOMER = '7488486' or ac.JOINT_HOLDER LIKE '%7488486%')