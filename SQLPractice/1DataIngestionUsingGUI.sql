SHOW GRANTS TO USER sravi;

SELECT CURRENT_REGION();

-- Step 1: Create a database called 'star_insurance'
create database star_insurance;
-- Step 2: Create a schema called 'insurance_schema'
create or replace schema star_insurance.insurance_schema;

-- Step 3: Create a table called 'DimCustomer' under the schema called 'insurance_schema'
create or replace table star_insurance.insurance_schema.DimCustomer (
	CustomerKey  int  ,
	GeographyKey  int ,
	CustomerAlternateKey  varchar(15) ,
	Title  varchar(8) ,
	FirstName  varchar(50) ,
	MiddleName  varchar(50) ,
	LastName  varchar(50) ,
	NameStyle  int  ,
	BirthDate  varchar(50)  ,
	MaritalStatus  char(1) ,
	Suffix  varchar(10) ,
	Gender  varchar(1) ,
	EmailAddress  varchar(50) ,
	YearlyIncome  int  ,
	TotalChildren  int  ,
	NumberChildrenAtHome  int  ,
	EnglishEducation  varchar(40) ,
	SpanishEducation  varchar(40 ),
	FrenchEducation  varchar(40) ,
	EnglishOccupation  varchar(100) ,
	SpanishOccupation  varchar(100) ,
	FrenchOccupation  varchar(100) ,
	HouseOwnerFlag  char(1) ,
	NumberCarsOwned  int  ,
	AddressLine1  varchar(120) ,
	AddressLine2  varchar(120) ,
	Phone  varchar(20) ,
	DateFirstPurchase  varchar(50)  ,
	CommuteDistance  varchar(50)
);

select * from dimcustomer;
delete from dimcustomer;

-- Step 4: Create a Stage called 'MyStage'
create or replace stage star_insurance.insurance_schema.MyStage;

-- Step 5: Create a File Format called 'MyCSV'
create or replace file format star_insurance.insurance_schema.MyCSV type = csv skip_header = 1;

-- Step 6: PUT command will not work in the Query file
--PUT file://D:\RaviData\SnowFlake\Exercise\Dimcustomer9.csv @MyStage;
--put FILE://D:\RaviData\SnowFlake\Exercise\Dimcustomer9.csv @mystage;


list@MyStage;
ls@MyStage;

-- Step 7: COPY command will copy the data from file and insert into the table.
copy into star_insurance.insurance_schema.dimcustomer from @MyStage file_format = mycsv;

SELECT CURRENT_REGION();

