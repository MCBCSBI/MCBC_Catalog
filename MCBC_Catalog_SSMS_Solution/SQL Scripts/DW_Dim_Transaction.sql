declare @businessdate date = '2019-04-09';

with f as
(
--FT
	select
		f.mis_date,
		'FT' as Tran_Group
		,ft.[@ID]
		,ft.TRANSACTION_TYPE as TRANSACTION_TYPE
		,f.DESCRIPTION
		,ft.CREDIT_THEIR_REF as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,ft.TREASURY_RATE as RATE
		,ft.CUSTOMER_RATE as INTEREST_APPLIED
		,ft.CREDIT_VALUE_DATE as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,ft.REVERSAL_MKR as REVERSAL_MARKER
		,ft.INW_SEND_BIC
		,CASE WHEN ft.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
	from bs.FUNDS_TRANSFER ft 
		left outer join bs.FT_TXN_TYPE_CONDITION f on ft.TRANSACTION_TYPE=f.[@ID] and ft.MIS_DATE=f.MIS_DATE
			
	where --ft.PROCESSING_DATE = @businessdate
	--and 
	f.DESCRIPTION like ('%Salary%')

)

,t as 
(
--Teller
	select
		 t.mis_date,
		'TT' as Tran_Group
		,tt.[@ID]
		,convert(nvarchar(5),t.[@ID]) as TRANSACTION_TYPE
		,t.[DESC] DESCRIPTION
		,tt.THEIR_REFERENCE as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,tt.DEAL_RATE as RATE
		,tt.RATE_2 as INTEREST_RATE
		,tt.VALUE_DATE_2 as VALUE_DATE
		,NULL MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN tt.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,tt.TELLER_ID_1 as TELLER_ID
	from bs.TELLER tt 
		left outer join bs.TELLER_TRANSACTION t on tt.TRANSACTION_CODE=t.[@ID] and tt.MIS_DATE=t.MIS_DATE
	where tt.MIS_DATE = @businessdate
)

,s as 
(
--Security
	select
		ST.mis_date,
		'SC' as Tran_Group
		,ST.[@ID]
		,ST.PRICE_TYPE TRANSACTION_TYPE
		,CONCAT(s1.short_name,' ', s2.SHORT_NAME) as DESCRIPTION
		,sm.COMPANY_NAME as TRANSACTION_REFERENCE
		,sm.[@ID] as TRANSACTION_REFERENCE_NUMBER
		,sm.CPN_RATE as RATE
		,st.INTEREST_RATE as INTEREST_APPLIED
		,st.VALUE_DATE
		,st.MATURITY_DATE
		,sm.ISSUE_DATE
		,sm.DISC_YLD_PERC DISCOUNT_RATE
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN st.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
	from [BS].[SEC_TRADE] ST 
		left outer join bs.sc_trans_name s1 on s1.[@ID]=ST.CUST_TRANS_CODE and s1.MIS_DATE=ST.MIS_DATE
		left outer join bs.sc_trans_name s2 on s2.[@ID]=ST.BR_TRANS_CODE and s2.MIS_DATE=ST.MIS_DATE
		left outer join bs.SECURITY_MASTER sm on st.SECURITY_CODE=sm.[@ID] and st.MIS_DATE=sm.MIS_DATE
	where ST.mis_date = @businessdate
)
,d as 
(
--Data Capture
	select
		d.mis_date,
		'DC' as Tran_Group
		,DC.[@ID]
		,d.TRANSACTION_TYPE as TRANSACTION_TYPE
		,d.NARRATIVE DESCRIPTION
		,dc.OUR_REFERENCE as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,dc.EXCHANGE_RATE as RATE
		,NULL as INTEREST_RATE
		,dc.VALUE_DATE as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,dc.REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN dc.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
	from [BS].[DATA_CAPTURE] DC 
		left outer join bs.[TRANSACTION] d on DC.TRANSACTION_CODE=d.[@ID] and DC.MIS_DATE=d.MIS_DATE

	where 
		DC.mis_date = @businessdate
		and data_capture = 'Y'
)
/*,g as
(
	select
		g.mis_date,
		'GENERAL' as Tran_Group
		,g.[@ID]
		,g.NARRATIVE
	from bs.[TRANSACTION] g
	where 
		g.mis_date = @businessdate
		and g.data_capture is null
)
*/

,fo as
(
--Forex
	select distinct 
		 f.DEAL_DATE
		,'FOREX' as Tran_Group
		,f.[@ID]
		,f.TRANSACTION_TYPE as Transaction_Type
		,f.SWIFT_COMMON_REF as DESCRIPTION
		,f.SWIFT_COMMON_REF as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,f.TREASURY_RATE as RATE
		,f.INT_RATE_SELL as [INTEREST_RATE]
		,NULL as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE	
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN f.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
		from BS.Forex f 
			
		where	f.DEAL_DATE = @businessdate
		
)

,ac as
(
--Activities
	
	select distinct 
		 AA.EFFECTIVE_DATE
		,'ACTIVITIES' as Tran_Group
		,AA.[@ID] as [@ID]
		,NULL as TRANSACTION_TYPE
	    ,AA.ACTIVITY as DESCRIPTION
		,NULL as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,AA.TXN_EXCH_RATE as RATE
		,NULL as INTEREST_RATE
		,NULL as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN AA.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
		from BS.AA_ARRANGEMENT_ACTIVITY AA 
			--inner join bs.STMT_ENTRY ST on AA.[@ID]=ST.TRANS_REFERENCE

		where AA.EFFECTIVE_DATE=@businessdate
		
)

,so as
(
--Standing Order
	
	select distinct 
		 SO.MIS_DATE
		,'Standing Order' as Tran_Group
		,CAST(SO.[@ID] as nvarchar(50)) [@ID]
		,SO.TYPE as TRANSACTION_TYPE
	    ,SO.PAYMENT_DETAILS as DESCRIPTION
		,CASE WHEN t01.value IS NULL or ltrim(t01.value)='' THEN 'PASSED SO' ELSE 'FAILED SO' END as NAME
		,CASE WHEN SUBSTRING(CURRENT_FREQUENCY,11,1) <>0
			THEN SUBSTRING(CURRENT_FREQUENCY,11,2)
			ELSE 
				CASE WHEN SUBSTRING(CURRENT_FREQUENCY,15,1) <>0
				THEN SUBSTRING(CURRENT_FREQUENCY,15,2)
				ELSE
					CASE WHEN SUBSTRING(CURRENT_FREQUENCY,19,1) <>0
					THEN SUBSTRING(CURRENT_FREQUENCY,19,2)
					ELSE SUBSTRING(CURRENT_FREQUENCY,23,2)
					END
				END	
			END as TRANSACTION_REFERENCE_NUMBER
		,NULL as RATE
		,NULL as INTEREST_RATE
		,SO.LAST_RUN_DATE as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN so.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
		from BS.STANDING_ORDER SO 
		cross apply
	(
		select
			ROW_NUMBER() over (order by ISNULL(so.RETRY_ORIG_DATE,'') asc) as rw
			,t.value
		from
			string_split(ISNULL(so.RETRY_ORIG_DATE,''),nchar(63741)) t
	)t01

		where SO.MIS_DATE=@businessdate
		
)

,charge as
(
--Charge
	
	select distinct 
		 CH.MIS_DATE
		,'CHARGES' as Tran_Group
		,CH.[@ID] as [@ID]
		,CH.CHARGE_CODE as TRANSACTION_TYPE
	    ,COM.DESCRIPTION
		,CH.RELATED_REF as TRANSACTION_REFERENCE
		,NULL as TRANSACTION_REFERENCE_NUMBER
		,NULL as RATE
		,NULL as INTEREST_RATE
		,CH.CHARGE_DATE as VALUE_DATE
		,NULL as MATURITY_DATE
		,NULL as ISSUE_DATE
		,NULL AS DISCOUNT_RATE
		,NULL as REVERSAL_MARKER
		,NULL as INW_SEND_BIC
		,CASE WHEN ch.INPUTTER like ('%SFIUSER1%') THEN 'SYSTEM' ELSE 'USER' END as USER_TYPE
		,NULL as TELLER_ID
        from BS.AC_CHARGE_REQUEST CH 
			 left join bs.FT_COMMISSION_TYPE COM on CH.CHARGE_CODE=COM.[@ID]

		where CH.MIS_DATE=@businessdate
		
)

select 
		 t.MIS_DATE
		,t.Tran_Group
		,t.[@ID]
		,t.TRANSACTION_TYPE
		,t.[DESCRIPTION]
		,t.TRANSACTION_REFERENCE
		,t.TRANSACTION_REFERENCE_NUMBER
		,t.RATE
		,t.INTEREST_APPLIED
		,t.VALUE_DATE
		,t.MATURITY_DATE
		,t.ISSUE_DATE
		,CAST(t.DISCOUNT_RATE as DECIMAL(19,2)) DISCOUNT_RATE
		,t.REVERSAL_MARKER
		,t.INW_SEND_BIC
		,t.USER_TYPE
		,t.TELLER_ID
		,[Hash_SCD2]=
			isnull(
				convert(char(66),HASHBYTES('SHA2_256',concat(t.Tran_Group,t.[@id],t.DESCRIPTION,t.TRANSACTION_REFERENCE,t.TRANSACTION_REFERENCE_NUMBER,t.RATE,t.INTEREST_APPLIED,t.VALUE_DATE,t.MATURITY_DATE,t.ISSUE_DATE,t.DISCOUNT_RATE,t.REVERSAL_MARKER,t.INW_SEND_BIC,t.USER_TYPE,t.TELLER_ID)),1),
				0
			) 

from
(
		select * from f
	union
		select * from t
	union
		select * from s
	union
		select * from d
	union
		select * from fo
	union
		select * from ac
	union
		select * from so
	union
		select * from charge
--	union
--		select * from g

) t




