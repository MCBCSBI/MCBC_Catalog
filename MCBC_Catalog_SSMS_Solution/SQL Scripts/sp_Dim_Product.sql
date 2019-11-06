--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_product'

declare @sql nvarchar(max) =
'drop table if exists dim_product

		create table Dim_Product
		(
			Product_Key int not null identity (1,1)
			,Product_ID nvarchar(25) not null
			,Product_Description nvarchar(35)
			,Product_Group_1 nvarchar(45)
			,scd2_start datetime not null
			,scd2_end datetime
			,scd2_hash char(66) not null
		)

		alter table dim_product
			add constraint pk_dim_product primary key clustered (Product_key)

		set identity_insert dim_product on

		insert into Dim_Product (Product_Key,Product_ID,scd2_start,scd2_hash)
			values
				(-1,-1,-1,-1)'

begin try
exec(
'create procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end try

begin catch
exec(
'alter procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end catch


