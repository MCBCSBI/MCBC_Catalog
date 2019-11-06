with c as 
(
	select 
		c.MIS_DATE,
		c.[@ID] as COLLATERAL_ID
		,c.ETL_COLLATERAL_RIGHT
		,c.COLLATERAL_TYPE
		,c.DESCRIPTION as COLL_TYPE_DESC
		,r.COLLATERAL_CODE
		,d.DESCRIPTION as COLLATERAL_CODE_DESC
		,CAST(SUBSTRING(c.REVIEW_DATE_FQU,1,8) as DATETIME) REVIEW_DATE
		,c.VALUE_DATE
		,c.EXPIRY_DATE as COLL_EXP_DATE
		,CONVERT(XML,'<localref><attr>'+replace(replace(c.local_ref,'&','&amp;'),nchar(63741),'</attr><attr>')+'</attr></localref>') as localref_xml --BRAJUG: Add a replace function from '&' to '&amp; 
	from
		bs.COLLATERAL c
		left join bs.COLLATERAL_RIGHT r
			on r.MIS_DATE = c.MIS_DATE
			and r.[@ID] = c.ETL_COLLATERAL_RIGHT
		left join bs.COLLATERAL_CODE d
			on c.MIS_DATE = d.MIS_DATE
			and c.COLLATERAL_CODE = d.[@ID]
)

select 
	c.MIS_DATE,
	c.COLLATERAL_ID
	,c.ETL_COLLATERAL_RIGHT
	,c.COLLATERAL_TYPE
	,c.COLL_TYPE_DESC
	,c.COLLATERAL_CODE
	,c.COLLATERAL_CODE_DESC
	,c.REVIEW_DATE
	,c.VALUE_DATE
	,c.COLL_EXP_DATE
	,c.localref_xml.value('/localref[1]/attr[1]','nvarchar(50)') as Car_Prv_Owner,
	c.localref_xml.value('/localref[1]/attr[2]','nvarchar(50)') as Car_Dealer,
	c.localref_xml.value('/localref[1]/attr[3]','nvarchar(50)') as Vehicle_Model,
	c.localref_xml.value('/localref[1]/attr[4]','nvarchar(50)') as License_No,
	c.localref_xml.value('/localref[1]/attr[5]','nvarchar(50)') as Register_No,
	c.localref_xml.value('/localref[1]/attr[6]','nvarchar(50)') as Manufacturer,
	c.localref_xml.value('/localref[1]/attr[7]','nvarchar(50)') as Engine_Number,
	c.localref_xml.value('/localref[1]/attr[8]','nvarchar(50)') as Chassis_No,
	c.localref_xml.value('/localref[1]/attr[9]','nvarchar(50)') as Manufacture_Y,
	c.localref_xml.value('/localref[1]/attr[10]','nvarchar(50)') as Car_Policy_No,
	c.localref_xml.value('/localref[1]/attr[11]','nvarchar(50)') as Car_Premium,
	c.localref_xml.value('/localref[1]/attr[12]','nvarchar(50)') as Broker_Name,
	c.localref_xml.value('/localref[1]/attr[13]','nvarchar(50)') as Broker_Phone_no,
	c.localref_xml.value('/localref[1]/attr[14]','nvarchar(50)') as Insurance_Coverage,
	substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),1,4)
	+'-'+substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),5,2)
	+'-'+substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),7,2)
	 as Ins_Expiry_Date
	 ,Hash_SCD2 = isnull(
		convert(char(66),HASHBYTES(
							'SHA2_256'
							,concat(
							c.COLLATERAL_ID
							,c.ETL_COLLATERAL_RIGHT
							,c.COLLATERAL_TYPE
							,c.COLLATERAL_CODE_DESC
							,c.COLLATERAL_CODE
							,c.COLLATERAL_CODE_DESC
							,c.REVIEW_DATE
							,c.VALUE_DATE
							,c.COLL_EXP_DATE
							,c.localref_xml.value('/localref[1]/attr[1]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[2]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[3]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[4]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[5]','nvarchar(50)'),
							c.localref_xml.value('/localref[1]/attr[6]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[7]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[8]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[9]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[10]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[11]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[12]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[13]','nvarchar(50)') ,
							c.localref_xml.value('/localref[1]/attr[14]','nvarchar(50)') ,
							substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),1,4)
							+'-'+substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),5,2)
							+'-'+substring(c.localref_xml.value('/localref[1]/attr[15]','nvarchar(50)'),7,2)
							)),1),
		0
	)
from 
	c
where MIS_DATE = '2019-06-07'