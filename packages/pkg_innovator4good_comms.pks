create or replace package pkg_innovator4good_comms
as
  co_nutrition_tips_col constant varchar2(255) := 'COL_NUTRITION_TIPS';

  procedure get_entity_information_icd_api (
      in_entity_id in number
    , out_response    out clob
  );

  procedure get_completion_chatgpt_api (
    in_prompt    in  clob,
    out_response out clob
  );

  procedure add_nutrients (
      in_date               in date
    , in_nutrition_fact_ids in apex_t_number
    , in_amount             in number
  );
end pkg_innovator4good_comms;
/
