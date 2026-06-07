

use role sysadmin;

-- Create a database to store our schemas.
create database raw;

-- Create the schema. The schema stores all our objectss.
create schema raw.git;

/*
    Warehouses are synonymous with the idea of compute
    resources in other systems. We will use this
    warehouse to call our user defined function.
*/
create warehouse if not exists developer 
    warehouse_size = xsmall
    initially_suspended = true;

use database raw;
use schema git;
use warehouse developer;



use role accountadmin;

create secret github_secret
    type = password
    username = 'Ravi-zen'
    password = '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';

create api integration git_api_integration
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/Ravi-zen')
    allowed_authentication_secrets = (github_secret)
    enabled = true;

create git repository sf_tutorial
    api_integration = git_api_integration
    git_credentials = github_secret
    origin = 'https://github.com/Ravi-zen/SnowflakeWithAI';




-- Show repos added to snowflake.
show git repositories;

-- Show branches in the repo.
show git branches in git repository sf_tutorial;

-- List files.
ls @sf_tutorial/branches/main;RAW.GIT.SF_TUTORIAL

-- Show code in file.
select $1 from @sf_tutorial/branches/main/1DataIngestionUsingGUI.sql;

-- Fetch git repository updates.
alter git repository sf_tutorial fetch;
    


-- Run the files in Snowflake.
execute immediate from @sf_tutorial/branches/main/1DataIngestionUsingGUI.sql;
execute immediate from @sf_tutorial/branches/main/2Practice.sql;
execute immediate from @sf_tutorial/branches/main/3Practice1.sql;
execute immediate from @sf_tutorial/branches/main/4Functions.sql;
execute immediate from @sf_tutorial/branches/main/5Procedures.sql;
execute immediate from @sf_tutorial/branches/main/6SFTables.sql;
execute immediate from @sf_tutorial/branches/main/7LoadXMLToSnowFlake.sql;
execute immediate from @sf_tutorial/branches/main/8LoadJsonFileToSnowFlake.sql;
execute immediate from @sf_tutorial/branches/main/9AdminAtivities.sql;
execute immediate from @sf_tutorial/branches/main/10RBAC.sql;



-- Create snowpark procedure
create or replace procedure hello()
    returns string
    language python 
    runtime_version= '3.8'
    packages=('snowflake-snowpark-python')
    imports=('@tutorial/branches/main/examples/hello.py')
    handler='hello.main';

call hello();
