alter procedure sp_dim_collateral
as

begin
	drop table if exists dim_collateral
	create table Dim_Collateral
	(
		 Collateral_Key int not null identity (1,1)
		,Collateral_ID nvarchar(25)
		,Collateral_Right_ID nvarchar(25)
		,Collateral_Type int
		,Collateral_Type_Description nvarchar(255)
		,Collateral_Code int
		,Collateral_Code_Description nvarchar(255)
		,Collateral_Review_Date datetime
		,Collateral_Value_Date datetime
		,Collateral_Expiration_Date datetime
		,Car_Prv_Owner nvarchar(50)
		,Car_Dealer nvarchar(50)
		,Vehicle_Model nvarchar(50)
		,License_No nvarchar(50)
		,Register_No nvarchar(50)
		,Manufacturer nvarchar(50)
		,Engine_No nvarchar(50)
		,Chassis_No nvarchar(50)
		,Manufacture_Y nvarchar(50)
		,Car_Policy_No nvarchar(50)
		,Car_Premium nvarchar(50)
		,Broker_Name nvarchar(50)
		,Broker_Phone_no nvarchar(50)
		,Insurance_Coverage nvarchar(50)
		,Insurance_Expiry_Date nvarchar(50)
		,scd2_start datetime not null
		,scd2_end datetime 
		,scd2_hash char(66) not null
	)

	alter table Dim_Collateral
		add
			 constraint pk_dim_coll primary key clustered(Collateral_Key)
end