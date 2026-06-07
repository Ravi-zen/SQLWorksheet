create or replace database sf_tuts;

select current_database(), current_schema();

create or replace table emp_basic (
    first_name string,
    last_name string,
    email string,
    streetaddress string,
    city string,
    start_date date
);

create or replace warehouse sf_tuts_wh with
warehouse_size = 'XSMALL'
auto_suspend = 180
auto_resume = true
initially_suspended = true ;

select current_warehouse();

put file://D:\RaviData\SnowFlake\Exercise\getting-started\employees0*.csv @sf_tuts.public.%emp_basic;

LIST@sf_tuts.public.%emp_basic;
rm@sf_tuts.public.%emp_basic;

COPY INTO emp_basic
FROM @sf_tuts.public.%emp_basic
FILE_FORMAT = (TYPE = 'CSV' field_optionally_enclosed_by = '"')
PATTERN = '.*employees0.*.csv.gz'
ON_ERROR = 'skip_file';

select * from emp_basic;

truncate table emp_basic;
