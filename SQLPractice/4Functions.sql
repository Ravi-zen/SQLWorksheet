-- User Defined Functions.
-- Example 1:
create or replace function resort.resort_schema.addnum ( a number, b number )
returns number
language sql
AS
$$
    a+b
$$;

select resort.resort_schema.addnum(24,0);

-- Example 2:
create or replace function resort.resort_schema.stringcancatination ( a varchar, b varchar )
returns varchar
language sql
AS
$$
    a || ' ' || b
$$;

select resort.resort_schema.stringcancatination('Snow flake','is a DataWarehous.');

-- Example create a function that check the Ae is valid or not using Javascript without exception handling

create or replace function resort.resort_schema.validate_age( AGE float)
returns varchar()
language javascript
AS
$$
    if( AGE < 0 ){
        throw "AGE can't be Negative !"
    }
    else{
        return "AGE is Validated."
    }
$$;

select resort.resort_schema.validate_age( -24 );

-- Example 3: create a function that check the Ae is valid or not using Javascript  with exception handling

create or replace function resort.resort_schema.validate_age1( AGE float)
returns varchar()
language javascript
AS
$$
    try{
        if( AGE <= 0 ){
            throw "AGE can't be less than or equal to Zero !"
        }
        else{
            return "AGE is Validated."
        }
    }
    catch (err) {
        return "Error:" +err
    }
$$;

select resort.resort_schema.validate_age1( 0 );


-- Example 4: The finally block always runs whether an error occurs or not — useful for cleanup, logging, or appending metadata.
-- Try-Catch-Finally: Finally block always executes regardless of error
create or replace function resort.resort_schema.divide_numbers(N1 float, D1 float)
returns varchar
language javascript
AS
$$
var result = "";
try {
    if (D1 === 0) {
        throw "Division by zero is not allowed!";
    }
    result = "Result: " + (N1 / D1);
}
catch (err) {
    result = "Error: " + err;
}
finally {
    result = result + " | Execution completed.";
}
return result;
$$;

select resort.resort_schema.divide_numbers(10, 2);
select resort.resort_schema.divide_numbers(10, 0);


-- Example 5: Here we are Adding extra amount to claim_amount column
-- using the user defined function(UDF's); DB: POLICY_HOLDERS_DB, SCHMA: POLICY_HOLDERS_SCHEMA
-- Table: POLICY_HOLDERS
select * from POLICY_HOLDERS;

create or replace function resort.resort_schema.extra_claim ( claim number )
returns number
language sql
AS
$$
    claim + 2000
$$;

select * from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;
select claim_amount, resort.resort_schema.extra_claim(claim_amount) from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;
update POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS set claim_amount = resort.resort_schema.extra_claim(claim_amount);


-- Example 6: Created a function with the case statement 

create or replace function resort.resort_schema.udf_bignumber( n1 float, n2 float)
returns float
AS
$$
    select 
       case when n1>n2 then n1
            else n2
       end
$$;

select resort.resort_schema.udf_bignumber(86.9 , 32.99);
select resort.resort_schema.udf_bignumber(32.99 , 86.9);

select * from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;


-- Example 7: Created a function with the case statement with SQL

create or replace function resort.resort_schema.test_sql( n1 float)
returns varchar
language sql
AS
$$
    select 
       case when n1 < 252000 then 'Low Amount'
            when n1 > 252000 then 'High Amount'
            else 'Medium Amount'
       end
$$;

select *, resort.resort_schema.test_sql(claim_amount) from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;

-- Example 8: Created a function with the case statement with snowflake scripting

create or replace function resort.resort_schema.test_snowflake_script(n1 FLOAT)
returns VARCHAR
language SQL
AS
$$
DECLARE
    a FLOAT DEFAULT 252000;
BEGIN
    RETURN CASE WHEN n1 < a THEN 'Low Amount'
                WHEN n1 > a THEN 'High Amount'
                ELSE 'Medium Amount'
           END;
END;
$$;

select *, resort.resort_schema.test_snowflake_script(claim_amount) from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;

-- Example 9: Created a function with the Nested IF statement with snowflake scripting

create or replace function resort.resort_schema.test_javascript(N1 FLOAT)
returns VARCHAR
language JAVASCRIPT
AS
$$
    var a = 252000;
    if (N1 < a) {
        return 'Low Amount';
    } else if (N1 > a) {
        return 'High Amount';
    } else {
        return 'Medium Amount';
    }
$$;

select *, resort.resort_schema.test_javascript(claim_amount) from POLICY_HOLDERS_DB.POLICY_HOLDERS_SCHEMA.POLICY_HOLDERS;


-- Example 10: Try-Catch-Finally: Input validation with cleanup logging
create or replace function resort.resort_schema.process_patient_age(AGE float, NAME varchar)
returns varchar
language javascript
AS
$$
var status = "unprocessed";
try {
    if (AGE === undefined || NAME === undefined) {
        throw "Both AGE and NAME are required!";
    }
    if (AGE < 0 || AGE > 150) {
        throw "Invalid AGE: must be between 0 and 150.";
    }
    status = "Patient " + NAME + " (Age: " + AGE + ") validated successfully.";
}
catch (err) {
    status = "Validation Failed - " + err;
}
finally {
    status = status + " [Processed at: " + new Date().toDateString() + "]";
}
return status;
$$;

select resort.resort_schema.process_patient_age(25, 'John');
select resort.resort_schema.process_patient_age(-5, 'Jane');
select resort.resort_schema.process_patient_age(200, 'Bob');


-- Example 11: Try-Catch-Finally: Nested try-catch with finally in Body Mass Index calculation 
create or replace function resort.resort_schema.calculate_bmi(WEIGHT float, HEIGHT float)
returns varchar
language javascript
AS
$$
var log = "";
try {
    try {
        if (WEIGHT <= 0) throw "Weight must be positive!";
        if (HEIGHT <= 0) throw "Height must be positive!";
    }
    catch (validationErr) {
        throw "Input Validation Error: " + validationErr;
    }

    var bmi = WEIGHT / (HEIGHT * HEIGHT);

    if (bmi < 18.5) return "BMI: " + bmi.toFixed(2) + " (Underweight)";
    else if (bmi < 25) return "BMI: " + bmi.toFixed(2) + " (Normal)";
    else if (bmi < 30) return "BMI: " + bmi.toFixed(2) + " (Overweight)";
    else return "BMI: " + bmi.toFixed(2) + " (Obese)";
}
catch (err) {
    log = "Error: " + err;
}
finally {
    if (log !== "") return log + " | Please provide valid inputs.";
}
$$;

select resort.resort_schema.calculate_bmi(70, 1.75);
select resort.resort_schema.calculate_bmi(-10, 1.75);
select resort.resort_schema.calculate_bmi(70, 0);


-- Example 12: Runtime errors automatically generated by JavaScript engine (caught with try-catch)
-- These errors are NOT manually thrown — they occur naturally during execution

-- Example 1: TypeError - calling a method on undefined/null
create or replace function resort.resort_schema.parse_json_value(INPUT varchar)
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

select resort.resort_schema.parse_json_value('{"name": "John"}');
select resort.resort_schema.parse_json_value('{"age": 25}');
select resort.resort_schema.parse_json_value('invalid json');


-- Example 13: RangeError - invalid array length, stack overflow
create or replace function resort.resort_schema.create_array(SIZE float)
returns varchar
language javascript
AS
$$
try {
    var arr = new Array(SIZE);
    return "Array created with length: " + arr.length;
}
catch (err) {
    return "Runtime Error: " + err.name + " - " + err.message;
}
$$;

select resort.resort_schema.create_array(5);
select resort.resort_schema.create_array(-1);


-- Example 14: SyntaxError - invalid JSON parsing at runtime
create or replace function resort.resort_schema.extract_field(JSON_STR varchar, FIELD varchar)
returns varchar
language javascript
AS
$$
try {
    var data = JSON.parse(JSON_STR);
    if (data[FIELD] === undefined) {
        return "Field '" + FIELD + "' not found in JSON.";
    }
    return "Value: " + data[FIELD];
}
catch (err) {
    return "Runtime Error: " + err.name + " - " + err.message;
}
$$;

select resort.resort_schema.extract_field('{"city": "New York"}', 'city');
select resort.resort_schema.extract_field('{broken json}', 'city');
select resort.resort_schema.extract_field('{"city": "New York"}', 'state');


-- Example 15: URIError - malformed URI encoding
create or replace function resort.resort_schema.decode_url(URL varchar)
returns varchar
language javascript
AS
$$
try {
    return decodeURIComponent(URL);
}
catch (err) {
    return "Runtime Error: " + err.name + " - " + err.message;
}
$$;

select resort.resort_schema.decode_url('Hello%20World');
select resort.resort_schema.decode_url('%E0%A4%A');


-- Example 16: Multiple runtime error types with error object properties
create or replace function resort.resort_schema.safe_compute(A float, B float, OPERATION varchar)
returns varchar
language javascript
AS
$$
try {
    var result;
    switch(OPERATION) {
        case "divide":
            if (B === 0) result = Infinity;
            else result = A / B;
            break;
        case "power":
            result = Math.pow(A, B);
            break;
        case "sqrt":
            if (A < 0) throw new RangeError("Cannot sqrt negative number");
            result = Math.sqrt(A);
            break;
        default:
            result = undefined;
            result.toString();
    }
    return "Result: " + result;
}
catch (err) {
    return "Error Type: " + err.name + " | Message: " + err.message + " | Stack: " + (err.stack || "N/A");
}
$$;

select resort.resort_schema.safe_compute(10, 2, 'divide');
select resort.resort_schema.safe_compute(10, 0, 'divide');
select resort.resort_schema.safe_compute(-4, 0, 'sqrt');
select resort.resort_schema.safe_compute(10, 2, 'modulus');

