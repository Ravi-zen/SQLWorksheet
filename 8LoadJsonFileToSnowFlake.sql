-- Create a table for json raw with single column as a 'src'.
create table if not exists json_raw( src variant );

-- Create a new Stage for Json
create stage if not exists myjson;

-- Create a File Format for Json
create file format if not exists myjson type = json;

-- -- Put command to be run on snowSQL CLI

-- Copy the Json data into a table created above.
copy into json_raw from @myjson
file_format = myjson
files = ('mydata.json.gz');


select * from json_raw;

select src:device_type::string as device_type,
       src:events as events,
       src:version as version
from json_raw;

-- The loaded data in the single column can be seperated using Lateral flatten parameter which is in the value column
select * from json_raw, lateral flatten(input => src:events);

-- use the value column and pick each following data.
select src:device_type::string as device_type,
       value:f::number         as f,
       value:rv::variant       as rv,
       value:t::number         as t,
       value:v:ACHZ::number    as ACHZ,
       value:v:ACV::number     as ACV,
       value:v:DCA::number     as DCA,
       value:v:DCV::number     as DCV,
       value:v:ENJR::number    as ENJR,
       value:v:ERRS::number    as ERRS,
       value:v:MXEC::number    as MXEC,
       value:v:TMPI::number    as TMPI,
       value:vd::number        as vd,
       value:z::number         as z,
       src:version::string     as version
from json_raw, lateral flatten(input => src:events);

-- Flatten and extract into a final table
create table events as 
select src:device_type::string as device_type,
       value:f::number         as f,
       value:rv::variant       as rv,
       value:t::number         as t,
       value:v:ACHZ::number    as ACHZ,
       value:v:ACV::number     as ACV,
       value:v:DCA::number     as DCA,
       value:v:DCV::number     as DCV,
       value:v:ENJR::number    as ENJR,
       value:v:ERRS::number    as ERRS,
       value:v:MXEC::number    as MXEC,
       value:v:TMPI::number    as TMPI,
       value:vd::number        as vd,
       value:z::number         as z,
       src:version::string     as version
from json_raw, lateral flatten(input => src:events);

select * from events;

--------------------------------------

-- Step 1: Create a stage to store the JSON file
CREATE OR REPLACE STAGE json_stage;

-- Step 2: Upload the file to the stage (run this in SnowSQL CLI)
-- PUT file:///path/to/mydata.json @json_stage AUTO_COMPRESS=TRUE;

-- Step 3: Load raw JSON into a VARIANT table
CREATE OR REPLACE TABLE json_raw (src VARIANT);

COPY INTO json_raw
FROM @json_stage/mydata.json.gz
FILE_FORMAT = (TYPE = 'JSON');

-- Step 4: Verify the raw load
SELECT * FROM json_raw;

-- Step 5: Flatten and extract into a final table
CREATE OR REPLACE TABLE events AS
SELECT
    src:device_type::STRING   AS device_type,
    src:version::FLOAT        AS version,
    e.value:f::NUMBER         AS f,
    e.value:rv::STRING        AS rv,
    e.value:t::NUMBER         AS t,
    e.value:v:ACHZ::NUMBER    AS achz,
    e.value:v:ACV::NUMBER     AS acv,
    e.value:v:DCA::NUMBER     AS dca,
    e.value:v:DCV::NUMBER     AS dcv,
    e.value:v:ENJR::NUMBER    AS enjr,
    e.value:v:ERRS::NUMBER    AS errs,
    e.value:v:MXEC::NUMBER    AS mxec,
    e.value:v:TMPI::NUMBER    AS tmpi,
    e.value:vd::NUMBER        AS vd,
    e.value:z::NUMBER         AS z
FROM json_raw,
LATERAL FLATTEN(input => src:events) e;

-- Step 6: Query the final table
SELECT * FROM events;






