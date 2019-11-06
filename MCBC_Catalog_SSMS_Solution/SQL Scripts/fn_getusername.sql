alter function fn_getusername(@fieldname nvarchar(200))
returns nvarchar(25)
as
begin
	return
		case when 
			CHARINDEX('_',@fieldname,CHARINDEX('_',@fieldname)+1) = 0
			then
			SUBSTRING(@fieldname,CHARINDEX('_',@fieldname)+1,(len(@fieldname)-CHARINDEX('_',@fieldname)))
			else
			SUBSTRING(@fieldname,CHARINDEX('_',@fieldname)+1,(CHARINDEX('_',@fieldname,CHARINDEX('_',@fieldname)+1)-CHARINDEX('_',@fieldname)-1))
		end

end