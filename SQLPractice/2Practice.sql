-- Create a student table contains sid,sname fields
create or replace table student( sid int primary key, sname varchar(15) );

-- Inserting the records into the student table
insert into student ( sid, sname ) values ( 1, 'Rahul'), ( 2, 'Venu');

select * from student;
delete from student;

-- PUT file://D:\RaviData\SnowFlake\Exercise\student.csv @mystage

copy into student from @mystage file_format=mycsv;


-- Create a Course table contains cid, cname fields
create or replace table course( cid int primary key, cname varchar(15) );

-- Inserting the records into the course table
insert into course ( cid, cname ) values ( 1, 'Java'), ( 2, 'Python');

select * from course;
delete from course;

-- PUT file://D:\RaviData\SnowFlake\Exercise\course.csv @mystage

copy into course from @mystage file_format=mycsv;

drop table student;
drop table course;

-- Create Student table
CREATE OR REPLACE TABLE STAR_INSURANCE.INSURANCE_SCHEMA.student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

-- Insert records into Student table
INSERT INTO STAR_INSURANCE.INSURANCE_SCHEMA.student (student_id, student_name)
VALUES
    (1, 'Rahul'),
    (2, 'Priya'),
    (3, 'Amit'),
    (4, 'Sneha'),
    (5, 'Vikram');

-- Create Course table
CREATE OR REPLACE TABLE STAR_INSURANCE.INSURANCE_SCHEMA.course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Insert records into Course table
INSERT INTO STAR_INSURANCE.INSURANCE_SCHEMA.course (course_id, course_name)
VALUES
    (101, 'Java'),
    (102, 'Python'),
    (103, 'SQL'),
    (104, 'Snowflake'),
    (105, 'Data Engineering');





-- Create DEPARTMENTS table
CREATE OR REPLACE TABLE STAR_INSURANCE.INSURANCE_SCHEMA.DEPARTMENTS (
    DEPT_ID INT PRIMARY KEY,
    DEPT_NAME VARCHAR(100) NOT NULL UNIQUE
);

-- Create EMPLOYEES table
CREATE OR REPLACE TABLE STAR_INSURANCE.INSURANCE_SCHEMA.EMPLOYEES (
    EMP_ID INT PRIMARY KEY,
    EMP_NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(150) NOT NULL UNIQUE,
    SALARY NUMBER(12,2) NOT NULL CHECK (SALARY > 0),
    DEPT_ID INT NOT NULL,
    CONSTRAINT FK_DEPT FOREIGN KEY (DEPT_ID) REFERENCES STAR_INSURANCE.INSURANCE_SCHEMA.DEPARTMENTS(DEPT_ID)
);

-- Insert records into DEPARTMENTS
INSERT INTO STAR_INSURANCE.INSURANCE_SCHEMA.DEPARTMENTS (DEPT_ID, DEPT_NAME)
VALUES
    (1, 'Human Resources'),
    (2, 'Engineering'),
    (3, 'Finance');

-- Insert records into EMPLOYEES
INSERT INTO STAR_INSURANCE.INSURANCE_SCHEMA.EMPLOYEES (EMP_ID, EMP_NAME, EMAIL, SALARY, DEPT_ID)
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
FROM STAR_INSURANCE.INSURANCE_SCHEMA.EMPLOYEES E
JOIN STAR_INSURANCE.INSURANCE_SCHEMA.DEPARTMENTS D
    ON E.DEPT_ID = D.DEPT_ID;







-- 1) Create a new database called VEHICLE_INSURANCE_DB, create a schema and create a table called VEHICLE_CUSTOMERS.
-- Now create a stage and CSV file format, upload the CSV file using PUT command with AUTO_COMPRESS enabled, load the data into table.


create database VEHICLE_INSURANCE_DB;

create schema VEHICLE_INSURANCE_SCHEMA;

create or replace table VEHICLE_CUSTOMERS (
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

create stage myvehiclestage;

ls@myvehiclestage;

create file format mycsv type = csv skip_header = 1;

-- PUT file://D:\RaviData\SnowFlake\Exercise\insurance_file.csv @myvehiclestage auto_compress = true;

copy into VEHICLE_CUSTOMERS from @myvehiclestage file_format = mycsv;

select * from VEHICLE_CUSTOMERS;


-- 2. Create complete Snowflake setup to load health insurance claims CSV data into a table called CLAIMS_DATA.
-- Make sure header rows are not loaded into target table.

create database HEALTH_INSURANCE_DB;

create schema HEALTH_INSURANCE_SCHEMA;

create or replace table CLAIMS_DATA (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    claim_reason text,
    claim_date date,
    claim_amount float
);

create stage myclaimstage;

rm@myclaimstage;

create file format mycsv type = csv skip_header = 1;

-- PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @myclaimstage;

copy into CLAIMS_DATA from @myclaimstage file_format=mycsv;


select * from CLAIMS_DATA;



-- 3. Create database, schema, table called POLICY_HOLDERS, stage and file format.
-- Upload CSV file using PUT command and load data into Snowflake table.
-- After uploading, verify whether file exists in stage before loading.


create database POLICY_HOLDERS_DB;

create schema POLICY_HOLDERS_SCHEMA;

create or replace table POLICY_HOLDERS (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    claim_reason text,
    claim_date date,
    claim_amount float
);

create stage policystage;

create file format mycsv type = csv skip_header = 1;

-- PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @policystage;

-- After uplaod of csv file below command is used to find the file is uploaded or not.
ls@policystage;

copy into POLICY_HOLDERS from @policystage file_format=mycsv;


select * from POLICY_HOLDERS;



-- 4.  Perform end-to-end Snowflake implementation to load renewal customer CSV data into table CUSTOMER_RENEWALS.
-- Finally display all records from target table.


create database CUSTOMER_RENEWALS_DB;

create schema CUSTOMER_RENEWALS_SCHEMA;

create or replace table CUSTOMER_RENEWALS (
    insurance_name varchar(25),
    insurance_number integer,
    p_name varchar(20),
    renewal date,
    claim_date date
);

create stage policystage;

create file format mycsv type = csv skip_header = 1;

-- PUT file://D:\RaviData\SnowFlake\Exercise\CLAIMS_DATA.csv @policystage;

-- After uplaod of csv file below command is used to find the file is uploaded or not.
ls@policystage;

copy into CUSTOMER_RENEWALS from @policystage file_format=mycsv;


select * from CUSTOMER_RENEWALS;
