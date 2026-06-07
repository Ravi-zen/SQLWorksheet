use role accountadmin;
use warehouse compute_wh;
use database star_insurance;
use schema insurance_schema;
select * from DIMCUSTOMER;
ls@mycsv;

put 'FILE://D:\\RaviData\\SnowFlake\\Exercise\\getting-started\\*.csv' @mycsv;
put 'FILE://D:\\RaviData\\SnowFlake\\Exercise\\getting-started\\*.csv' @mycsv overwrite = true;
put 'FILE://D:\\RaviData\\SnowFlake\\Exercise\\getting-started\\*.csv' @mycsv overwrite = true auto_compress=false;
put 'FILE://D:\\RaviData\\SnowFlake\\Exercise\\getting-started\\*.csv' @mycsv overwrite = true auto_compress=false Parallel = 99;
PUT 'FILE://D:/RaviData/SnowFlake/Exercise/getting-started/*.csv' @mycsv OVERWRITE = TRUE;
remove@mycsv;



create or replace file format my_csv_format
    type = 'CSV'
    field_delimiter = '~'
    skip_header = 1
    field_optionally_enclosed_by = '"';

desc table student;
truncate table student;

ALTER TABLE student
  ADD COLUMN age int,
  address VARCHAR(150),
  pincode VARCHAR(20);

put file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\student.csv @mystage overwrite = true;

select * from student;
copy into student from @mycsv
file_format = my_csv_format
files = ('student.csv.gz');

select * from table(
  information_schema.copy_history(
    table_name => 'student',
    start_time => dateadd(hour, -1, current_timestamp())
  )
);


PUT file://D:\RaviData\SnowFlake\Exercise\resort.csv @mycsv overwrite=true auto_compress=false parallel=99;



PUT file://D:\RaviData\SnowFlake\Exercise\insurance_file.csv @myvehiclestage auto_compress = true;



PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @myclaimstage;



PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @policystage;



PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @policystage;

stages/997a2229-23d5-4fc2-8cab-0365df7708e6/;




put file://D:/RaviData/SnowFlake/Exercise/mydata.json @myjson;
put file://D:/RaviData/SnowFlake/Exercise/A_20080403_1.xml @xml_stage;

ls @xml_stage;


show roles;
show warehouses;
show databases;
show schemas;
show tables;


put file://D:\RaviData\SnowFlake\Exercise\data.csv @mycsv;
