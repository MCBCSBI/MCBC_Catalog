SELECT 
		 C.MIS_DATE 
		,C.[@ID]
		,Concat(C.[@ID],isnull(C.Risk_Asset_Type,'-1'),isnull(C.Risk_Level,'-1')
		,isnull(C.Risk_Tolerance,'-1'),isnull(C.Risk_from_Date,'1900-01-01')) Customer_Risk_ID
		,C.Risk_Asset_Type
		,Asset_Desc.ASSET_DESC Risk_Asset_Type_Desc
		,C.Risk_Level
		,C.Risk_Tolerance
		,CAST(C.Risk_From_Date as date) Risk_From_Date
		
		

    ,[Scd2_Hash] =
		(isnull(convert(char(66),HASHBYTES('SHA2_256',concat(
			   C.[@ID]
			  ,C.Risk_Asset_Type
			  ,Asset_Desc.ASSET_DESC
			  ,C.Risk_Level
			  ,C.Risk_Tolerance
			  ,C.Risk_From_Date
		)),1),0))
		
FROM 
	 [InsightLanding].[BS].[CUSTOMER_Risk_Asset_Type] C
	 Left join [InsightLanding].[BS].[ASSET_TYPE] Asset_Desc on Asset_Desc.[@ID]=C.Risk_Asset_Type and Asset_Desc.MIS_DATE=C.MIS_DATE

where (C.Risk_Asset_Type is not null or C.Risk_Level is not null or C.Risk_Tolerance is not null or C.Risk_From_Date is not null)
and c.mis_date = '2019-06-10'--?


