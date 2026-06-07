select * from testdb.test_schema.departments;
select * from testdb.test_schema.employees;

insert into testdb.test_schema.employees (EMP_ID, EMP_NAME, EMAIL, SALARY, DEPT_ID) values 
(104, 'Goutham Raj', 'goutham@gmail.com', 78000, 2),
(105, 'Raj Kumar', 'raj@gmail.com', 82000, 2),
(106, 'Nitin', 'nitin@gmail.com', 86000, 1),
(107, 'Varma', 'varma@gmail.com', 88000, 3);


-- Step 1: Create a mapping table that links Snowflake usernames to DEPT_ID
CREATE TABLE IF NOT EXISTS testdb.test_schema.USER_DEPT_MAPPING (
    USERNAME VARCHAR(100) NOT NULL,
    DEPT_ID NUMBER(38,0) NOT NULL
);

-- Step 2: Insert sample mappings (adjust usernames/dept_ids as needed)
INSERT INTO testdb.test_schema.USER_DEPT_MAPPING (USERNAME, DEPT_ID)
VALUES
    ('SRAVI', 1),
    ('TEST_USE1', 2);

-- Step 3: Create the row access policy
CREATE OR REPLACE ROW ACCESS POLICY testdb.test_schema.RAP_DEPT_ACCESS
AS (dept_id NUMBER) RETURNS BOOLEAN ->
    IS_ROLE_IN_SESSION('ACCOUNTADMIN')
    OR EXISTS (
        SELECT 1
        FROM testdb.test_schema.USER_DEPT_MAPPING m
        WHERE m.USERNAME = CURRENT_USER()
          AND m.DEPT_ID = dept_id
    );

-- Step 4: Apply the row access policy to EMPLOYEES table
ALTER TABLE testdb.test_schema.EMPLOYEES
    ADD ROW ACCESS POLICY testdb.test_schema.RAP_DEPT_ACCESS ON (DEPT_ID);

-- Step 5: Apply the row access policy to DEPARTMENTS table
ALTER TABLE testdb.test_schema.DEPARTMENTS
    ADD ROW ACCESS POLICY testdb.test_schema.RAP_DEPT_ACCESS ON (DEPT_ID);

-- Step 6: Create a masking policy on EMAIL column
CREATE OR REPLACE MASKING POLICY testdb.test_schema.MASK_EMAIL
AS (val VARCHAR) RETURNS VARCHAR ->
    CASE
        WHEN IS_ROLE_IN_SESSION('ACCOUNTADMIN') THEN val
        ELSE CONCAT('***@', SPLIT_PART(val, '@', 2))
    END;

-- Step 7: Apply the masking policy to EMPLOYEES.EMAIL
ALTER TABLE testdb.test_schema.EMPLOYEES
    MODIFY COLUMN EMAIL SET MASKING POLICY testdb.test_schema.MASK_EMAIL;

-- Drop masking policy from EMPLOYEES table
ALTER TABLE testdb.test_schema.EMPLOYEES
    MODIFY COLUMN EMAIL UNSET MASKING POLICY;

DROP MASKING POLICY testdb.test_schema.MASK_EMAIL;


-- Step 8: Create a masking policy on SALARY column
CREATE OR REPLACE MASKING POLICY testdb.test_schema.MASK_SALARY
AS (val NUMBER) RETURNS NUMBER ->
    CASE
        WHEN IS_ROLE_IN_SESSION('ACCOUNTADMIN') THEN val
        ELSE NULL
    END;

-- Step 7: Apply the masking policy to EMPLOYEES.EMAIL
ALTER TABLE testdb.test_schema.EMPLOYEES
    MODIFY COLUMN SALARY SET MASKING POLICY testdb.test_schema.MASK_SALARY;

-- Drop masking policy from EMPLOYEES table
ALTER TABLE testdb.test_schema.EMPLOYEES
    MODIFY COLUMN SALARY UNSET MASKING POLICY;

DROP MASKING POLICY testdb.test_schema.MASK_SALARY;
