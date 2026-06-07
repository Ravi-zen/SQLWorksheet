-- To load any of the file (csv,json,avro,orc,xml,parquet) data into a table,
-- we need to follow a few of the steps.
-- 1) create table
-- 2) stage
-- 3) put
-- 4) file format
-- 5) copy

-- To create a table and stage we required a Database.
create database resort;

-- Create a shema in the resort database
create or replace schema resort.resort_schema;

-- Step 1:- Create a table called customer_details, which can be seen within in the schema
create or replace table resort.resort_schema.customer_details(
    CustomerID integer,
    FirstName varchar(10),
    LastName varchar(10),
    Email varchar(15),
    CheckInDate date,
    CheckOutDate date,
    RoomType varchar(6),
    Guests integer
);

select * from resort.resort_schema.customer_details;

alter table resort.resort_schema.customer_details modify column Email varchar(25);
alter table resort.resort_schema.customer_details modify column RoomType varchar(10);

-- Step 2:- Create a stage called mystage, which can be seen within in the schema
create or replace stage resort.resort_schema.mystage;

-- Step 3:- Load the Data file from internal storage to mystage, with the 
-- help of PUT command.This will work in the SnowSQL CLI.
-- We can use the some of the parameters like OVERWRITE default false, 
-- PARALLEL default '3' and max is '99', AUTO_COMPRESS default true

PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\resort.csv @resort.resort_schema.mystage 
overwrite=true auto_compress=false parallel=99;

ls@resort.resort_schema.mystage;

rm@resort.resort_schema.mystage;

-- Step 4:- Create a file format, which can be seen within in the schema
-- We can use the some of the parameters like skip_header default 0, 
-- field_delimiter default ',', field_optionally_enclosed_by default '"'

create or replace file format resort.resort_schema.mycsv type='csv' 
skip_header=1 field_delimiter=',' field_optionally_enclosed_by='"';


-- Step 5:- Copy command will load the data into a table

-- Before that we need to check or validate is any error in the file for that
-- we have a query 'validate_mode'. If no error found simple insert to the table
-- or provides the list of error found without inserting of any data.

copy into resort.resort_schema.customer_details from @resort.resort_schema.mystage 
file_format = resort.resort_schema.mycsv
files = ('resort.csv')
VALIDATION_MODE = 'RETURN_ALL_ERRORS';


copy into resort.resort_schema.customer_details from @resort.resort_schema.mystage 
file_format = resort.resort_schema.mycsv
files = ('resort.csv')
--on_error=continue;
on_error=skip_file;


truncate table resort.resort_schema.customer_details;


-- To find the copy history for a file.

select * from table(
  information_schema.copy_history(
    table_name => 'customer_details',
    start_time => dateadd(day, -1, current_timestamp())
  )
);


SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'RESORT.RESORT_SCHEMA.CUSTOMER_DETAILS',
    START_TIME => DATEADD(DAY, -2, CURRENT_TIMESTAMP())
))
WHERE STATUS = 'Load failed' OR STATUS = 'PARTIALLY LOADED'
ORDER BY LAST_LOAD_TIME DESC;


SELECT * FROM TABLE(VALIDATE(customer_details, JOB_ID => '_last'));


SELECT QUERY_ID, QUERY_TEXT, START_TIME
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE QUERY_TEXT ILIKE '%COPY INTO%'
ORDER BY START_TIME DESC
LIMIT 5;


-- Variables are used to help us to in multiple ways,
-- One of the example is when we want to search with a single values
-- in multiple queries then variable will hepl us to change in one place
-- that will initilize to all where we called the variable.

set cname = 'John';

select $cname;

select * from resort.resort_schema.customer_details where firstname = $cname;

unset cname;

select $cname;


-- TOP
select TOP 2 * from resort.resort_schema.customer_details;

select TOP 1 firstname, lastname, email from resort.resort_schema.customer_details;


-- LIMIT
select * from resort.resort_schema.customer_details LIMIT 2;

select firstname, lastname, email from resort.resort_schema.customer_details LIMIT 1;


-- OFFSET
select * from resort.resort_schema.customer_details LIMIT 2 offset 1;

select firstname, lastname, email from resort.resort_schema.customer_details LIMIT 1 offset 2;


-- FETCH

select * from resort.resort_schema.customer_details order by guests fetch 2 rows only;

select * from resort.resort_schema.customer_details order by guests fetch first 3 rows only;
-- FETCH NEXT 5 ROWS ONLY — equivalent to FIRST, fetches next 5 rows (after ORDER BY)
select * from resort.resort_schema.customer_details order by checkindate desc fetch next 5 rows only;

select * from resort.resort_schema.customer_details order by guests offset 2 rows fetch first 3 rows only;


-- TO_DATE() and DATE()
-- Converts the string into DATE format.

select to_date('21-02-2026','DD-MM-YYYY');
select date('21/02/2026', 'DD/MM/YYYY');

SELECT TO_VARCHAR('2021-11-03'::DATE, 'DD-MM-YYYY');
SELECT date(2021-11-03);

-- SYSTEM$TYPEOF() function will give more detailed data type info (includes length/precision)

SELECT SYSTEM$TYPEOF(TO_VARCHAR('2021-11-03'::DATE, 'DD-MM-YYYY'));
SELECT SYSTEM$TYPEOF(date(2021-11-03));

-- EXTRACT()

select extract(day, to_date('21-02-2024','DD-MM-YYYY'));
select extract(month, to_date('21-02-2024','DD-MM-YYYY'));
select extract(year, to_date('21-02-2024','DD-MM-YYYY'));

select extract(day, to_date('21/02/2024','DD/MM/YYYY'));
select extract(month, to_date('21/02/2024','DD/MM/YYYY'));
select extract(year, to_date('21/02/2024','DD/MM/YYYY'));

select extract(day, to_date('2024-02-03','yyyy-mm-dd'));
select extract(month, to_date('2024-02-03','yyyy-mm-dd'));
select extract(year, to_date('2024-02-03','yyyy-mm-dd'));

-- calander functions

select day(to_date('2024-02-03','yyyy-mm-dd'));
select month(to_date('2024-02-03','yyyy-mm-dd'));
select year(to_date('2024-02-03','yyyy-mm-dd'));


-- ADD_MONTHS()

select add_months('2026-05-21 16:19:35'::date,3);

-- DATEADD()

select dateadd(month,3,'2026-05-21'::date);

-- DATE_TRUNC()

select date_trunc(week, '2026-05-21'::date);

-- upper(), lower() and initcap()

select upper(firstname), lower(lastname), initcap(lastname) from resort.resort_schema.customer_details;


create or replace function parse_json_value(INPUT varchar)
returns varchar
language javascript
AS
$$
try {
    var obj = JSON.parse(INPUT);
    return obj.name.toUpperCase();
}
catch (err) {
    return "Runtime Error: " + err.name + " - " + err.message;
}
$$;

