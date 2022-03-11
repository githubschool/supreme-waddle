create or replace package body pkg_application_query
as
   procedure validate_application_doc_id
    ( p_document_id       in     application_document.document_id%type
    , p_old_mod_ts        in     application_document.last_mod_ts%type
    )
   is
      l_count_entity              binary_integer;
      l_count_fresh               binary_integer;
      l_table_name                user_tables.table_name%type := 'APPLICATION_DOCUMENT';
   begin
      select count( * ) count_entity
           , count( case last_mod_ts
                       when p_old_mod_ts
                       then
                          pkg_constant.yes_flg
                       else
                          null
                    end
                  ) count_fresh
        into l_count_entity
           , l_count_fresh
        from application_document
       where document_id = p_document_id;
      if l_count_entity < 1
      then
         pkg_err.send_entity_does_not_exist
          ( l_table_name
          , to_char( p_document_id )
          );
      elsif l_count_fresh < 1
      then
         pkg_err.send_row_has_changed
          ( l_table_name
          , to_char( p_document_id )
          );
      end if;

   end validate_application_doc_id;

end pkg_application_query;
/

