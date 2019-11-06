declare @BusinessDate date = '2019-09-30';
with t as 
(
	SELECT
		'STMT' as [Entry Type],
		stmt.LEAD_CO_MNE,
		stmt.BRANCH_CO_MNE,
		stmt.MIS_DATE,
		stmt.[@ID] as [ID],
		stmt.ACCOUNT_NUMBER as [Account No],
		stmt.AMOUNT_LCY as Amount_Lcy,
		stmt.AMOUNT_FCY as Amount_Fcy,
		stmt.CURRENCY,
		stmt.CRF_TYPE as Asset_Type,
		stmt.PRODUCT_CATEGORY as Product_Category,
		stmt.PL_CATEGORY as Pl_Category,
		stmt.BOOKING_DATE as Booking_Date,
		case when
			charindex('\',stmt.TRANS_REFERENCE)>0
		then 
			left(stmt.TRANS_REFERENCE,charindex('\',stmt.TRANS_REFERENCE)-1) 
		else 
			stmt.TRANS_REFERENCE
		end as trans_reference,--to remove the /BNK after the transaction ID
		stmt.OUR_REFERENCE,
		stmt.THEIR_REFERENCE,
		stmt.TRANSACTION_CODE,
		STMT.NARRATIVE,
		NULL AS AA_ITEM_REF,
		stmt.CONSOL_KEY,
		stmt.CUSTOMER_ID,
		stmt.SYSTEM_ID,
		stmt.REVERSAL_MARKER
	from 
		bnk_STMT_ENTRY as stmt
	where 
		stmt.BOOKING_DATE = @BusinessDate

   UNION ALL 
    
    select 
		'CATEG' ,
		categ.LEAD_CO_MNE,
		categ.BRANCH_CO_MNE,
		categ.MIS_DATE,
		categ.[@ID],
		categ.OUR_REFERENCE,
		categ.AMOUNT_LCY,
		categ.AMOUNT_FCY,
		categ.CURRENCY,
		categ.CURRENCY as Asset_Type,
		categ.PRODUCT_CATEGORY,
		categ.PL_CATEGORY,
		categ.BOOKING_DATE,
		categ.TRANS_REFERENCE,
		categ.OUR_REFERENCE,
		categ.THEIR_REFERENCE,
		categ.TRANSACTION_CODE,
		CATEG.NARRATIVE,
		NULL AS AA_ITEM_REF,
		categ.CONSOL_KEY,
		categ.CUSTOMER_ID,
		categ.SYSTEM_ID,
		categ.REVERSAL_MARKER
	from 
		bnk_CATEG_ENTRY as categ 
	where 
		categ.BOOKING_DATE = @BusinessDate
    
    UNION ALL
    
	select
        'SPEC',
		spec.LEAD_CO_MNE,
		spec.BRANCH_CO_MNE,
		spec.MIS_DATE,
        spec.[@ID],
		spec.DEAL_NUMBER,
        spec.AMOUNT_LCY,
		spec.AMOUNT_FCY,
		spec.CURRENCY,
		RIGHT(
			CONSOL_KEY_TYPE,
			(CAST(CHARINDEX('.',REVERSE(spec.CONSOL_KEY_TYPE)) AS INT)-1)
			) AS Asset_Type,
       spec.PRODUCT_CATEGORY,
       NULL AS PL_Category,
       spec.BOOKING_DATE,
       spec.TRANS_REFERENCE,
	   spec.OUR_REFERENCE,
	   null as THEIR_REFERENCE,
	   spec.TRANSACTION_CODE,
	   SPEC.NARRATIVE,
	   spec.AA_ITEM_REF AS AA_ITEM_REF,
	   left(
			CONSOL_KEY_TYPE,
			len(spec.CONSOL_KEY_TYPE)- CAST(CHARINDEX('.',REVERSE(spec.CONSOL_KEY_TYPE)) AS INT)
			) as CONSOL_KEY,
		spec.CUSTOMER_ID,
		spec.SYSTEM_ID,
		spec.REVERSAL_MARKER
    from
        bnk_RE_CONSOL_SPEC_ENTRY as spec
	where 
		spec.BOOKING_DATE = @BusinessDate
) 

select 
	 t.[Entry Type] as Entry_Type,
	t.BRANCH_CO_MNE
	,t.TRANS_REFERENCE
	,t.TRANSACTION_CODE
	,t.Booking_Date
	,CONCAT(t.[Entry Type],'.',t.ID) as Entry_ID -- to preserve uniqueness of rows
	,t.[Account No]
	,t.CONSOL_KEY
	,t.Asset_Type
	,t.Product_Category  
	,t.Pl_Category
	,t.REVERSAL_MARKER
	,sum(t.Amount_Lcy) as Amount_LCY 
	,sum(t.Amount_Fcy) as Amount_FCY
from t

where
	left(t.TRANS_REFERENCE,7)<>'SESSION'--exclude dummy entries
	and left(t.[Account No],3) <> 'NET' -- exclude consolidated acct entries - TEMPORARY MEASURE
group by
	 t.[Entry Type]
	,t.BRANCH_CO_MNE
	,t.TRANS_REFERENCE
	,t.TRANSACTION_CODE
	,t.Booking_Date
	,CONCAT(t.[Entry Type],'.',t.ID)
	,t.[Account No]
	,t.CONSOL_KEY
	,t.Asset_Type
	,t.Product_Category
	,t.Pl_Category
	,t.REVERSAL_MARKER