alter procedure sp_dim_User
as
	begin
		drop table if exists Dim_User

		create table Dim_User
		(
			 [User_Key] int not null identity (1,1)
			,[User_ID] nvarchar(50) not null
			,[User_name] nvarchar(150) 
			,[scd2_start] datetime 
			,[scd2_end] datetime
			,[scd2_hash] char(66) not null
		)

		alter table Dim_User
			add constraint pk_Dim_User primary key clustered (User_key)

        set identity_insert dim_User on

	    insert into Dim_User(User_key,[User_ID],Scd2_Hash)
			values
				(-1,'-1','-1')

	end

	--exec sp_Dim_User

	GO
