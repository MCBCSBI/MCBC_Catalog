create procedure sp_trnc_dim_gl_mapping
as

begin
	alter table dim_gl_mapping
		drop constraint fk_dim_gl

	alter table dim_gl
		drop constraint pk_dim_gl

	truncate table dim_gl_mapping

	alter table dim_gl_mapping
		add constraint fk_dim_gl foreign key(gl_key) references dim_gl(gl_key)

	alter table dim_gl
		add constraint pk_dim_gl primary key clustered (gl_key)
end
