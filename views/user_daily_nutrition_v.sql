create or replace view user_daily_nutrition_v as
select ud.user_id, ud.username, n.date_logged, --n.*, f.* 
       sum(HOUSEHOLD_WEIGHT) HOUSEHOLD_WEIGHT,
       sum(KILOCALORIES) KILOCALORIES, 
       sum(PROTEIN) PROTEIN,
       sum(CARBOHYDRATE) CARBOHYDRATE,
       sum(FIBER) FIBER,
       sum(TOTAL_FAT) TOTAL_FAT,
       sum(SATURATED_FAT) SATURATED_FAT,
       sum(CALCIUM) CALCIUM,
       sum(IRON) IRON,
       sum(ZINC) ZINC,
       sum(SODIUM) SODIUM,
       sum(VITAMIN_A) VITAMIN_A,
       sum(VITAMIN_C) VITAMIN_C,
       sum(VITAMIN_E) VITAMIN_E,
       sum(VITAMIN_K) VITAMIN_K
from user_daily_nutrition n
join nutrition_facts f
    on n.nutrition_id = f.id
join user_details ud
    on n.user_id = ud.user_id     
        and upper(username) = upper(v('APP_USER'))     
where trunc(n.date_logged) = to_date(v('P1_DATE'),'dd-mm-yyyy')       
group by ud.user_id, ud.username, n.date_logged
