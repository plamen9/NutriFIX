create or replace package body pkg_innovator4good_comms
as
  g_user constant user_details.email%type := nvl(v('APP_USER'), user);
  
  function get_user_id
  return user_details.user_id%type
  is
    l_user_id user_details.user_id%type;
  begin
    select ud.user_id
      into l_user_id
      from user_details ud
     where upper(ud.email) = upper(g_user);

    return l_user_id;   
  end get_user_id;

  procedure authenticate_icd_api
  is
    co_token_url     constant varchar2(1255) := 'https://icdaccessmanagement.who.int/connect/token';  
    co_client_id     constant varchar2(1255) := '4fa58301-2736-4beb-b0c8-a408a3c8860f_4274772d-9cfb-4304-be62-813de6da7f9f';
    co_client_secret constant varchar2(1255) := 'FxWk/rOW0IXbDJoJ80AI9OpgfgH8FY1YVdCpQHeF2t4=';
    co_scope         constant varchar2(1255) := 'icdapi_access';  
  begin
    --    MODIFIED   (MM/DD/YYYY)
    --    Mathias Maciel   05/13/2023 - Created.

    apex_web_service.oauth_authenticate (
        p_token_url     => co_token_url
      , p_client_id     => co_client_id
      , p_client_secret => co_client_secret
      , p_scope         => co_scope
    );
  end authenticate_icd_api;

  procedure get_entity_information_icd_api (
      in_entity_id in number
    , out_response    out clob
  )
  is
    co_base_url    constant varchar2(1255) := 'https://id.who.int';
    co_api_version constant varchar2(1255) := 'v2';
  begin
    --    MODIFIED   (MM/DD/YYYY)
    --    Mathias Maciel   05/13/2023 - Created.

    authenticate_icd_api;

    apex_web_service.g_request_headers.delete();
    apex_web_service.g_request_headers(1).name  := 'Authorization';
    apex_web_service.g_request_headers(1).value := 'Bearer ' || apex_web_service.oauth_get_last_token;
    apex_web_service.g_request_headers(2).name := 'Accept';
    apex_web_service.g_request_headers(2).value := 'application/json';
    apex_web_service.g_request_headers(3).name := 'API-Version';
    apex_web_service.g_request_headers(3).value := co_api_version;
    apex_web_service.g_request_headers(4).name := 'Accept-Language';
    apex_web_service.g_request_headers(4).value := 'en';

    out_response := apex_web_service.make_rest_request (
        p_url         => co_base_url || '/icd/entity/' || in_entity_id
      , p_http_method => 'GET'
    );
  end get_entity_information_icd_api;

  procedure get_completion_chatgpt_api (
    in_prompt    in  clob,
    out_response out clob
  )
  is
    /*pragma           autonomous_transaction;*/
    co_base_url      constant varchar2(1255) := 'https://api.openai.com/v1/completions';  
    co_client_secret constant varchar2(1255) := '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';
    l_body           varchar2(32767);
    l_response       clob;
    l_status_code    number;    
  begin
    --    MODIFIED   (MM/DD/YYYY)
    --    Mathias Maciel   05/13/2023 - Created.

    l_body := '{"prompt":"' || in_prompt || '","model":"text-davinci-003","temperature":0.7,"max_tokens":2000}';

    apex_web_service.g_request_headers.delete();
    apex_web_service.g_request_headers(1).name := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';
    apex_web_service.g_request_headers(2).name  := 'Authorization';
    apex_web_service.g_request_headers(2).value := 'Bearer ' || co_client_secret;      

    l_response := apex_web_service.make_rest_request (
        p_url         => co_base_url
      , p_http_method => 'POST'
      , p_body        => l_body
    );

    l_status_code := apex_web_service.g_status_code;

    if l_status_code != 200
    then
      raise_application_error(-20999, 'API request failed with status code: ' || l_status_code || ' - ' || l_response);
    else 
      out_response := l_response;    
    end if;
  end get_completion_chatgpt_api;

  procedure add_nutrients (
      in_date               in date
    , in_nutrition_fact_ids in apex_t_number
    , in_amount             in number
  )
  is        
    l_user_id user_details.user_id%type := get_user_id;
  begin
    if in_nutrition_fact_ids is empty
    then
      raise_application_error(-20999, 'Nutrient must have some value.');
    end if;
    
    if in_amount is null
    then
      raise_application_error(-20999, 'Amount must have some value.');
    end if;

    insert into user_daily_nutrition (
        user_id
      , date_logged
      , nutrition_id
      , nutrition_count      
    )
    select l_user_id
         , in_date
         , t.column_value
         , in_amount
      from table(in_nutrition_fact_ids) t;

    /*get_completion (
      in_prompt => in_prompt    
    );*/
  end add_nutrients;
end pkg_innovator4good_comms;
/
