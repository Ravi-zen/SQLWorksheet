-- Create a test DATABASE
create or replace database testdb;

--create a test SCHEMA
create or replace schema test_schema;

-- create a STAGE
create or replace stage TESTDB.TEST_SCHEMA.mystage;

-- create a file FORMAT
create or replace file format TESTDB.TEST_SCHEMA.mycsv type = csv skip_header = 1;

-- Create a student table contains sid,sname fields
create or replace table TESTDB.TEST_SCHEMA.student( sid int primary key, sname varchar(15) );

-- Inserting the records into the student table
insert into student ( sid, sname ) values ( 1, 'Rahul'), ( 2, 'Venu');

select * from TESTDB.TEST_SCHEMA.student;
delete from TESTDB.TEST_SCHEMA.student;

--PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\student.csv @TESTDB.TEST_SCHEMA.mystage;

copy into student from @TESTDB.TEST_SCHEMA.mystage file_format=mycsv files = ('student.csv.gz');


-- Create a Course table contains cid, cname fields
create or replace table TESTDB.TEST_SCHEMA.course( cid int primary key, cname varchar(15) );

-- Inserting the records into the course table
insert into course ( cid, cname ) values ( 1, 'Java'), ( 2, 'Python');

select * from TESTDB.TEST_SCHEMA.course;
delete from TESTDB.TEST_SCHEMA.course;

-- PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\course.csv @TESTDB.TEST_SCHEMA.mystage;

copy into course from @TESTDB.TEST_SCHEMA.mystage file_format=mycsv files = ('course.csv.gz');

drop table TESTDB.TEST_SCHEMA.student;
drop table TESTDB.TEST_SCHEMA.course;

-- Create Student table
CREATE OR REPLACE TABLE TESTDB.TEST_SCHEMA.student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

-- Insert records into Student table
INSERT INTO TESTDB.TEST_SCHEMA.student (student_id, student_name)
VALUES
    (1, 'Rahul'),
    (2, 'Priya'),
    (3, 'Amit'),
    (4, 'Sneha'),
    (5, 'Vikram');

-- Create Course table
CREATE OR REPLACE TABLE TESTDB.TEST_SCHEMA.course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Insert records into Course table
INSERT INTO TESTDB.TEST_SCHEMA.course (course_id, course_name)
VALUES
    (101, 'Java'),
    (102, 'Python'),
    (103, 'SQL'),
    (104, 'Snowflake'),
    (105, 'Data Engineering');


-- Create DEPARTMENTS table
CREATE OR REPLACE TABLE TESTDB.TEST_SCHEMA.DEPARTMENTS (
    DEPT_ID INT PRIMARY KEY,
    DEPT_NAME VARCHAR(100) NOT NULL UNIQUE
);

-- Create EMPLOYEES table
CREATE OR REPLACE TABLE TESTDB.TEST_SCHEMA.EMPLOYEES (
    EMP_ID INT PRIMARY KEY,
    EMP_NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(150) NOT NULL UNIQUE,
    SALARY NUMBER(12,2) NOT NULL CHECK (SALARY > 0),
    DEPT_ID INT NOT NULL,
    CONSTRAINT FK_DEPT FOREIGN KEY (DEPT_ID) REFERENCES TESTDB.TEST_SCHEMA.DEPARTMENTS(DEPT_ID)
);

-- Insert records into DEPARTMENTS
INSERT INTO TESTDB.TEST_SCHEMA.DEPARTMENTS (DEPT_ID, DEPT_NAME)
VALUES
    (1, 'Human Resources'),
    (2, 'Engineering'),
    (3, 'Finance');

-- Insert records into EMPLOYEES
INSERT INTO TESTDB.TEST_SCHEMA.EMPLOYEES (EMP_ID, EMP_NAME, EMAIL, SALARY, DEPT_ID)
VALUES
    (101, 'Rahul Sharma', 'rahul.sharma@company.com', 75000.00, 1),
    (102, 'Priya Patel', 'priya.patel@company.com', 92000.00, 2),
    (103, 'Amit Verma', 'amit.verma@company.com', 68000.00, 3);

-- Display Employee Name, Email, Salary, Department Name
SELECT
    E.EMP_NAME,
    E.EMAIL,
    E.SALARY,
    D.DEPT_NAME
FROM TESTDB.TEST_SCHEMA.EMPLOYEES E
JOIN TESTDB.TEST_SCHEMA.DEPARTMENTS D
    ON E.DEPT_ID = D.DEPT_ID;







-- 1) Create a new database called VEHICLE_INSURANCE_DB, create a schema and create a table called VEHICLE_CUSTOMERS.
-- Now create a stage and CSV file format, upload the CSV file using PUT command with AUTO_COMPRESS enabled, load the data into table.


create database VEHICLE_INSURANCE_DB;

create schema VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA;

create or replace table VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.VEHICLE_CUSTOMERS (
    vehicle_number varchar(10),
    owner_name varchar(15),
    eng_number integer,
    chas_number integer,
    insurance_name varchar(25),
    insurance_number integer,
    address varchar(20),
    start_date date,
    expire_date date    
);

create stage VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.myvehiclestage;

ls@VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.myvehiclestage;

create file format VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.mycsv type = csv skip_header = 1;

--PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\insurance_file.csv @VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.myvehiclestage auto_compress = true;

copy into VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.VEHICLE_CUSTOMERS from @VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.myvehiclestage file_format = mycsv;

select * from VEHICLE_INSURANCE_DB.VEHICLE_INSURANCE_SCHEMA.VEHICLE_CUSTOMERS;


-- 2. Create complete Snowflake setup to load health insurance claims CSV data into a table called CLAIMS_DATA.
-- Make sure header rows are not loaded into target table.

create database HEALTH_INSURANCE_DB;

create schema HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA;

create or replace table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    claim_reason text,
    claim_date date,
    claim_amount float
);

create stage HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.myclaimstage;

rm@HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.myclaimstage;

create file format HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.mycsv type = csv skip_header = 1;

--PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\CLAIMS_DATA.csv @HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.myclaimstage;

copy into HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA from @HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.myclaimstage file_format=mycsv;


select * from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA;



-- 3. Create database, schema, table called POLICY_HOLDERS, stage and file format.
-- Upload CSV file using PUT command and load data into Snowflake table.
-- After uploading, verify whether file exists in stage before loading.


create database POLICY_HOLDERS_DB;

create schema POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA;

create or replace table POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    claim_reason text,
    claim_date date,
    claim_amount float
);

create stage POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.policystage;

create file format POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.mycsv type = csv skip_header = 1;

-- PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\CLAIMS_DATA.csv @POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.policystage;

-- After uplaod of csv file below command is used to find the file is uploaded or not.
ls@POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.policystage;

copy into POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS from @POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.policystage file_format=mycsv;


select * from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;



-- 4.  Perform end-to-end Snowflake implementation to load renewal customer CSV data into table CUSTOMER_RENEWALS.
-- Finally display all records from target table.


create database CUSTOMER_RENEWALS_DB;

create schema CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA;

create or replace table CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.CUSTOMER_RENEWALS (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    renewal date,
    claim_date date
);

create stage CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.policystage;

create file format CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.mycsv type = csv skip_header = 1;

--PUT file://D:\RaviData\SnowFlake\Practice\DataFiles\CSV\POLICY_DATA.csv @CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.policystage;

-- After uplaod of csv file below command is used to find the file is uploaded or not.
ls@CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.policystage;

copy into CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.CUSTOMER_RENEWALS from @CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.policystage file_format=mycsv;


select * from CUSTOMER_RENEWALS_DB.CUSTOMER_RENEWALS_SCHEMA.CUSTOMER_RENEWALS;
