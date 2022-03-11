create or replace package body pkg_upload_query
as

   procedure validate_upload_spec_id
    ( p_upload_spec_id     in upload_spec.upload_spec_id%type
    , p_old_mod_ts         in upload_spec.last_mod_ts%type
    )
   is
      l_table_name            constant varchar(11) := 'upload_spec';
      l_count_exists          binary_integer;
      l_count_fresh           binary_integer;
   begin
      select count( * ) as count_exists
           , count( case last_mod_ts
                       when p_old_mod_ts
                       then
                          pkg_constant.yes_flg
                       else
                          null
                    end
                  ) as count_fresh
        into l_count_exists
           , l_count_fresh
        from upload_spec
       where upload_spec_id = p_upload_spec_id;

      if l_count_exists < 1
      then
         pkg_err.send_entity_does_not_exist
          ( l_table_name
          , to_char( p_upload_spec_id )
          );
      elsif l_count_fresh < 1
      then
         pkg_err.send_row_has_changed
          ( l_table_name
          , to_char( p_upload_spec_id )
          );
      end if;
   end validate_upload_spec_id;

   procedure validate_upload_id
    ( p_upload_id          in upload.upload_id%type
    )
   is
      l_table_name            constant varchar(11) := 'upload';
      l_count_exists          binary_integer;
   begin
      select count( * ) as count_exists
        into l_count_exists
        from upload
       where upload_id = p_upload_id;

      if l_count_exists < 1
      then
         pkg_err.send_entity_does_not_exist
          ( l_table_name
          , to_char( p_upload_id )
          );
      end if;
   end validate_upload_id;

end pkg_upload_query;
/
