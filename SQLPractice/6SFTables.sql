-- Creating Temporary table syntax

Create or replace temporary table testdb.test_schema.tmp_table(col1 number, col2 datetime);
select * from testdb.test_schema.tmp_table;

insert into testdb.test_schema.tmp_table (col1,col2) values (101, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (102, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (103, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (104, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (105, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (106, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (107, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (108, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (109, current_timestamp());
insert into testdb.test_schema.tmp_table (col1,col2) values (110, current_timestamp());

-- Below is the statements to check the table type.
select * from information_schema.tables where table_name = 'TMP_TABLE';
select table_name,table_type,is_transient,retention_time from information_schema.tables where table_name = 'TMP_TABLE';


-- Till now what ever we created those tables are Base/Permanent tables
select * from health_insurance_db.health_insurance_schema.claims_data;

-- For the Base/Permanent table time travle is 1 day, we can increase upto '90' days, fail safe is '7' days.
-- we can increase time travel days by parameter 'data_retention_time_in_days'.
alter table health_insurance_db.health_insurance_schema.claims_data set data_retention_time_in_days = 4;

update health_insurance_db.health_insurance_schema.claims_data set claim_amount = 202000 where p_name = 'John';

-- After update we can retrive original data back by time travle options
-- 1) OFFSET
-- 2) TIMESTAMP 
-- 3) Statement\Query Id

-- Using OFFSET Method (-sec*mins)
select * from health_insurance_db.health_insurance_schema.claims_data at (OFFSET => -60*19); 

-- Using TIMESTAMP Method.
select * from health_insurance_db.health_insurance_schema.claims_data at (TIMESTAMP => '2026-06-07'::TIMESTAMP); 

-- using Statement\Query Id
select * from health_insurance_db.health_insurance_schema.claims_data at ( statement => '01c4e3fc-0001-f0b6-001c-dff7000335b6');

select query_id, query_text, start_time
from table(information_schema.query_history())
where query_text like 'update health_insurance_db.health_insurance_schema.claims_data%'
order by start_time desc 
limit 5;


-- Below is the statements to check the table type.
select * from information_schema.tables where table_name = 'health_insurance_db.health_insurance_schema.CLAIMS_DATA';
select table_name,table_type,is_transient,retention_time from information_schema.tables where table_name = 'health_insurance_db.health_insurance_schema.CLAIMS_DATA';


-- Creating a Transient table

create or replace transient table health_insurance_db.health_insurance_schema.tra_claims_table (INSURANCE_NAME varchar, INSURANCE_NUMBER integer, P_NAME varchar, CLAIM_REASON varchar, CLAIM_DATE date, CLAIM_AMOUNT integer);

insert into health_insurance_db.health_insurance_schema.TRA_CLAIMS_TABLE select * from health_insurance_db.health_insurance_schema.claims_data;
select * from health_insurance_db.health_insurance_schema.TRA_CLAIMS_TABLE;

-- For Transient table time travel is '1' we can't increase it and the fail safe is '0'
alter table health_insurance_db.health_insurance_schema.TRA_CLAIMS_TABLE set data_retention_time_in_days = 1;


select * from information_schema.tables where table_name = 'health_insurance_db.health_insurance_schema.TRA_CLAIMS_TABLE';
select table_name,table_type,is_transient,retention_time from information_schema.tables where table_name = 'health_insurance_db.health_insurance_schema.TRA_CLAIMS_TABLE';



-- Zero copy cloning

create or replace transient table testdb.test_schema.tmp clone testdb.test_schema.tmp_table;

select * from testdb.test_schema.tmp;


show parameters in table testdb.test_schema.tmp;
show parameters in database health_insurance_db;
