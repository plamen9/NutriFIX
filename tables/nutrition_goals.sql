  CREATE TABLE "NUTRITION_GOALS" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
      "AGE" NUMBER, 
      "GENDER" VARCHAR2(50), 
      "KILOCALORIES" NUMBER, 
      "PROTEIN" NUMBER, 
      "CARBOHYDRATE" NUMBER, 
      "FIBER" NUMBER, 
      "TOTAL_FAT" NUMBER, 
      "SATURATED_FAT" NUMBER, 
      "CALCIUM" NUMBER, 
      "IRON" NUMBER, 
      "SODIUM" NUMBER, 
      "ZINC" NUMBER, 
      "VITAMIN_A" NUMBER, 
      "VITAMIN_E" NUMBER, 
      "VITAMIN_C" NUMBER, 
      "VITAMIN_K" NUMBER, 
       PRIMARY KEY ("ID")
      USING INDEX  ENABLE
   ) ;
