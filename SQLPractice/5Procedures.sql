show tables;

select * from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA;

-- create a dummy table called trg_claims_data
create or replace table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data ( insurance_name varchar(), p_name varchar(), claim_amount integer);

drop table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;

select * from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;

drop procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.insert_trg_claims_js();

-- After creating the above dummy table, 
-- Create a Procedure to Perform INSERT Operatio that copy entire data from original table to dummay table with Exception Handling using SQL
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_to_trg_claims( )
returns varchar
language sql
AS
$$
begin
    insert into HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data (insurance_name,p_name,claim_amount) select insurance_name, p_name, claim_amount from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA;
 
    return 'trg_claims_data inserted successfully';

    exception
        when statement_error then
            return 'Stmt_Error: ' || sqlcode || ' - ' || sqlerrm;
        when other then
            return 'Unexpected Error: ' || sqlcode || ' - ' || sqlerrm;

end
$$;

truncate table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;
call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_to_trg_claims();


-- Same procedure in JavaScript with try-catch exception handling
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_trg_claims_js()
returns varchar
language javascript
AS
$$
try {
    snowflake.execute({sqlText: "INSERT INTO HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data (insurance_name, p_name, claim_amount) SELECT insurance_name, p_name, claim_amount FROM HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA"});

    return "trg_claims_data inserted successfully";
}
catch (err) {
    return "Error: " + err.code + " - " + err.message;
}
$$;

truncate table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;
call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_trg_claims_js();


-- Same procedure in JavaScript with try-catch exception handling
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_trg_claims_js()
returns varchar
language javascript
AS
$$
try {

    var sql_cmd = 'insert into HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data (insurance_name, p_name, claim_amount) ' + 
                  'select insurance_name, p_name, claim_amount from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.CLAIMS_DATA;';

    var sql_stmt = snowflake.createStatement({sqlText: sql_cmd});

    sql_stmt.execute();

    return "trg_claims_data inserted successfully";
}
catch (err) {
    return "Error: " + err.code + " - " + err.message;
}
$$;

truncate table HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;
call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.cpy_trg_claims_js();


-- Create a Procedure to Perform Update Operation with Exception Handling using SQL
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.update_trg_claims_sql( PNAME varchar(), CAMOUNT integer)
returns varchar
language sql
AS
$$
begin
    update HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data 
    set claim_amount = :CAMOUNT 
    where p_name = :PNAME;

    if(sqlrowcount = 0 ) then
        return 'No matching record are found.';
    end if;

    return 'Updated in trg_claims_data successfully';

    exception
        when statement_error then
            return 'Stmt_Error: ' || sqlcode || ' - ' || sqlerrm;
        when expression_error then
            return 'Expr_Error: ' || sqlcode || ' - ' || sqlerrm;
        when other then
            return 'Unexpected Error: ' || sqlcode || ' - ' || sqlerrm;

end
$$;

call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.update_trg_claims_sql('John', 200000);


-- Create a Procedure to Perform Update Operation on insurance_name with Exception Handling using Javascript
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.update_insurance_name_js(PNAME varchar(), NEW_INSURANCE varchar())
returns varchar
language javascript
AS
$$

try {

    var sql_cmd = 'update HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data set insurance_name = ? where p_name = ?';

    var sql_stmt = snowflake.createStatement({sqlText: sql_cmd, binds: [NEW_INSURANCE, PNAME]});

    sql_stmt.execute();

    var rows_updated = sql_stmt.getNumRowsAffected();

    if(rows_updated === 0) {
        return 'No matching rows found';
    }

    return rows_updated + ' row(s) updated successfully';

}
catch(err) {

    return 'Error Code: ' + err.code +
           ' | State: ' + err.state +
           ' | Message: ' + err.message;

}

$$;

call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.update_insurance_name_js('John', 'Blue Cross');
select * from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;


-- Create a Procedure to Perform Delete Operation on insurance_name with Exception Handling using SQL
create or replace procedure HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.dl_trg_claims_sql ( PNAME varchar )
returns varchar
language SQL
AS
$$
    begin

        delete from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data where p_name = :PNAME;

        if (sqlrowcount = 0) then
            return 'No matching record found.';
        end if;

        return 'Deleted a record successfully.';

        exception
            when statement_error then
                return 'Stmt_Error: ' || sqlcode || ' - ' || sqlerrm;
            when expression_error then
                return 'Exp_Error: ' || sqlcode || ' - ' || sqlerrm;
            when other then
                return 'Unexpected Error: ' || sqlcode || ' - ' || sqlerrm;

    end
$$;

call HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.dl_trg_claims_sql('John');
select * from HEALTH_INSURANCE_DB.HEALTH_INSURANCE_SCHEMA.trg_claims_data;
