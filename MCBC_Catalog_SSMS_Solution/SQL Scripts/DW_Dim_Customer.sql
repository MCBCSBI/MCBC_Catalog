--use insightlanding_sey

SELECT 
	C.MIS_DATE
	,c.BRANCH_CO_MNE
	,C.[@ID] 
	,C.Name_1
	,C.Gender
	,DAO.NAME AS Account_Officer
	,C.Nationality
	,c.RESIDENCE
	,case when c.RESIDENCE = 'SC' then N'Resident' else N'Non-Resident' end as Residence_type
	,C.Customer_Type
	,CAST(C.Date_Of_Birth as DATE) Date_Of_Birth
	,SEC.DESCRIPTION AS Sector
	,tar.DESCRIPTION as Target
	,INS.DESCRIPTION AS Industry
	,C.Address
	,C.LEGAL_ID
	,C.CUSTOMER_SINCE
	,CAST(C.Contact_Date as DATE) Contact_Date
	,C.Introducer
	,C.Kyc_Relationship
	,CAST(C.Last_Kyc_Review_Date as DATE) Last_Kyc_Review_Date
	,CAST(C.Auto_Next_Kyc_Review_Date as DATE) Auto_Next_Kyc_Review_Date
	,CAST(C.Last_Suit_Review_Date as DATE) Last_Suit_Review_Date
	,CAST(C.Auto_Next_Suit_Review_Date as DATE) Auto_Next_Suit_Review_Date
	,CAST(C.Manual_Next_Kyc_Review_Date as DATE) Manual_Next_Kyc_Review_Date
	,CAST(C.Manual_Next_Suit_Review_Date as DATE) Manual_Next_Suit_Review_Date
	,C.Risk_Asset_Type
	,C.Risk_Level
	,C.Risk_Tolerance
	,concat(left(C.Risk_From_Date,4),'-',substring(C.Risk_From_Date,5,2),'-',right(C.Risk_From_Date,2)) as Risk_From_Dates
	,C.Aml_Check
	,C.Aml_Result
	,CAST(C.Last_Aml_Result_Date as DATE) Last_Aml_Result_Date
	,C.Calc_Risk_Class
	,C.Manual_Risk_Class
	,C.Override_Reason
	,C.Kyc_Complete
	,t01.value as Pref_Com_Channel
	,C.COMPANY_BOOK
	,b.company_name
    ,[Scd2_Hash] =
		(isnull(convert(char(66),HASHBYTES('SHA2_256',concat(
			C.[@ID] 
			,C.Name_1
			,c.BRANCH_CO_MNE
			,sec.DESCRIPTION
			,INS.DESCRIPTION
			,tar.DESCRIPTION
			,C.Gender
			,C.Account_Officer
			,C.Nationality
			,c.RESIDENCE
			,c.Residence_type
			,C.Customer_Type
			,C.Date_Of_Birth
			,C.Address
			,C.LEGAL_ID
			,C.CUSTOMER_SINCE
			,C.Contact_Date
			,C.Introducer
			--,CLREF.L_Kyc_Document
			,C.Kyc_Relationship
			,C.Last_Kyc_Review_Date
			,C.Auto_Next_Kyc_Review_Date
			,C.Last_Suit_Review_Date
			,C.Auto_Next_Suit_Review_Date
			,C.Manual_Next_Kyc_Review_Date
			,C.Manual_Next_Suit_Review_Date
			,C.Risk_Asset_Type
			,C.Risk_Level
			,C.Risk_Tolerance
			,C.Risk_From_Date
			,C.Aml_Check
			,C.Aml_Result
			,C.Last_Aml_Result_Date
			,C.Calc_Risk_Class
			,C.Manual_Risk_Class
			,C.Override_Reason
			,C.Kyc_Complete
			,t01.value
			,c.COMPANY_BOOK
			,b.company_name
		)),1),0))
		
FROM 
	[dbo].[BNK_CUSTOMER] C

	LEFT JOIN dbo.BNK_DEPT_ACCT_OFFICER DAO
		ON DAO.MIS_DATE = C.MIS_DATE
		AND DAO.[@ID] = C.ACCOUNT_OFFICER

	LEFT JOIN dbo.BNK_SECTOR SEC
		ON SEC.MIS_DATE = C.MIS_DATE 
		AND C.SECTOR = SEC.[@ID]

	LEFT JOIN dbo.BNK_LANGUAGE LAN
		ON LAN.MIS_DATE = C.MIS_DATE
		AND C.LANGUAGE = LAN.[@ID]

	LEFT JOIN dbo.BNK_COUNTRY COUN
		ON COUN.MIS_DATE = C.MIS_DATE
		AND COUN.[@ID] = C.COUNTRY

	LEFT JOIN dbo.BNK_INDUSTRY INS
		ON INS.MIS_DATE = C.MIS_DATE
		AND INS.[@ID] = C.INDUSTRY

	LEFT JOIN dbo.BNK_TARGET TAR
		ON TAR.MIS_DATE = C.MIS_DATE
		AND TAR.[@ID] = C.TARGET

	LEFT JOIN dbo.BNK_CUSTOMER_STATUS CUS_STATUS
		ON C.MIS_DATE = CUS_STATUS.MIS_DATE
		AND CUS_STATUS.[@ID] = C.CUSTOMER_STATUS

	left join bnk_company b
		on b.[@ID] = c.company_book
		and b.mis_date = c.mis_date 	

	cross apply
	(
		select 
			t.value
			,ROW_NUMBER() over (order by c.LOCAL_REF) as rw
		from string_split(c.LOCAL_REF,nchar(63741)) t
	)t01
	where t01.rw in (23) and c.mis_date = '2019-09-30'