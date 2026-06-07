-- Create a table for xml raw with single column as a 'xml_data'.
create table if not exists testdb.test_schema.xml_employee( xml_data variant);

-- Create a new Stage for xml_stage
create stage if not exists testdb.test_schema.xml_stage;

-- Create a File Format for XML
create file format if not exists testdb.test_schema.xml_format type = xml;

-- Put command to be run on snowSQL CLI
--put file://D:\RaviData\SnowFlake\Practice\DataFiles\XML\A_20080403_1.xml @testdb.test_schema.xml_stage;

-- Copy the XML data into a table created above.
copy into testdb.test_schema.xml_employee from @testdb.test_schema.xml_stage 
file_format = xml_format
files = ('A_20080403_1.xml.gz');

select * from testdb.test_schema.xml_employee;

select * from testdb.test_schema.xml_employee, lateral flatten(input => xml_data);
select * from testdb.test_schema.xml_employee, lateral flatten(to_array(xml_data : "$"));

select value from testdb.test_schema.xml_employee, lateral flatten(input => xml_data);
select value from testdb.test_schema.xml_employee, lateral flatten(to_array(xml_data : "$"));

create table if not exists testdb.test_schema.auction_data as
select 
xmlget(value, 'SecurityTermWeekYear'):"$"::string         as "SecurityTermWeekYear",
xmlget(value, 'SecurityTermDayMonth'):"$"::string         as "SecurityTermDayMonth",
xmlget(value, 'SecurityType'):"$"::string                 as "SecurityType",
xmlget(value, 'CUSIP'):"$"::string                        as "CUSIP",
xmlget(value, 'AnnouncementDate'):"$"::string             as "AnnouncementDate",
xmlget(value, 'AuctionDate'):"$"::string                  as "AuctionDate",
xmlget(value, 'IssueDate'):"$"::string                    as "IssueDate",
xmlget(value, 'MaturityDate'):"$"::string                 as "MaturityDate",
xmlget(value, 'OfferingAmount'):"$"::string               as "OfferingAmount",
xmlget(value, 'CompetitiveTenderAccepted'):"$"::string    as "CompetitiveTenderAccepted",
xmlget(value, 'NonCompetitiveTenderAccepted'):"$"::string as "NonCompetitiveTenderAccepted",
xmlget(value, 'TreasuryDirectTenderAccepted'):"$"::string as "TreasuryDirectTenderAccepted",
xmlget(value, 'AllTenderAccepted'):"$"::string            as "AllTenderAccepted",
xmlget(value, 'TypeOfAuction'):"$"::string                as "TypeOfAuction",
xmlget(value, 'CompetitiveClosingTime'):"$"::string       as "CompetitiveClosingTime",
xmlget(value, 'NonCompetitiveClosingTime'):"$"::string    as "NonCompetitiveClosingTime",
xmlget(value, 'NetLongPositionReport'):"$"::string        as "NetLongPositionReport",
xmlget(value, 'MaxAward'):"$"::string                     as "MaxAward",
xmlget(value, 'MaxSingleBid'):"$"::string                 as "MaxSingleBid",
xmlget(value, 'CompetitiveBidDecimals'):"$"::string       as "CompetitiveBidDecimals",
xmlget(value, 'CompetitiveBidIncrement'):"$"::string      as "CompetitiveBidIncrement",
xmlget(value, 'AllocationPercentageDecimals'):"$"::string as "AllocationPercentageDecimals",
xmlget(value, 'MinBidAmount'):"$"::string                 as "MinBidAmount",
xmlget(value, 'MultiplesToBid'):"$"::string               as "MultiplesToBid",
xmlget(value, 'MinToIssue'):"$"::string                   as "MinToIssue",
xmlget(value, 'MultiplesToIssue'):"$"::string             as "MultiplesToIssue",
xmlget(value, 'MatureSecurityAmount'):"$"::string         as "MatureSecurityAmount",
xmlget(value, 'CurrentlyOutstanding'):"$"::string         as "CurrentlyOutstanding",
xmlget(value, 'SOMAIncluded'):"$"::string                 as "SOMAIncluded",
xmlget(value, 'SOMAHoldings'):"$"::string                 as "SOMAHoldings",
xmlget(value, 'FIMAIncluded'):"$"::string                 as "FIMAIncluded",
xmlget(value, 'Series'):"$"::string                       as "Series",
xmlget(value, 'InterestRate'):"$"::string                 as "InterestRate",
xmlget(value, 'FirstInterestPaymentDate'):"$"::string     as "FirstInterestPaymentDate",
xmlget(value, 'StandardInterestPayment'):"$"::string      as "StandardInterestPayment",
xmlget(value, 'FrequencyInterestPayment'):"$"::string     as "FrequencyInterestPayment",
xmlget(value, 'StrippableIndicator'):"$"::string          as "StrippableIndicator",
xmlget(value, 'MinStripAmount'):"$"::string               as "MinStripAmount",
xmlget(value, 'CorpusCUSIP'):"$"::string                  as "CorpusCUSIP",
xmlget(value, 'TINTCUSIP1'):"$"::string                   as "TINTCUSIP1",
xmlget(value, 'TINTCUSIP2'):"$"::string                   as "TINTCUSIP2",
xmlget(value, 'ReOpeningIndicator'):"$"::string           as "ReOpeningIndicator",
xmlget(value, 'OriginalIssueDate'):"$"::string            as "OriginalIssueDate",
xmlget(value, 'BackDated'):"$"::string                    as "BackDated",
xmlget(value, 'BackDatedDate'):"$"::string                as "BackDatedDate",
xmlget(value, 'LongShortNormalCoupon'):"$"::string        as "LongShortNormalCoupon",
xmlget(value, 'LongShortCouponFirstIntPmt'):"$"::string   as "LongShortCouponFirstIntPmt",
xmlget(value, 'Callable'):"$"::string                     as "Callable",
xmlget(value, 'CallDate'):"$"::string                     as "CallDate",
xmlget(value, 'InflationIndexSecurity'):"$"::string       as "InflationIndexSecurity",
xmlget(value, 'RefCPIDatedDate'):"$"::string              as "RefCPIDatedDate",
xmlget(value, 'IndexRatioOnIssueDate'):"$"::string        as "IndexRatioOnIssueDate",
xmlget(value, 'CPIBasePeriod'):"$"::string                as "CPIBasePeriod",
xmlget(value, 'TIINConversionFactor'):"$"::string         as "TIINConversionFactor",
xmlget(value, 'AccruedInterest'):"$"::string              as "AccruedInterest",
xmlget(value, 'DatedDate'):"$"::string                    as "DatedDate",
xmlget(value, 'AnnouncedCUSIP'):"$"::string               as "AnnouncedCUSIP",
xmlget(value, 'UnadjustedPrice'):"$"::string              as "UnadjustedPrice",
xmlget(value, 'UnadjustedAccruedInterest'):"$"::string    as "UnadjustedAccruedInterest",
xmlget(value, 'ScheduledPurchasesInTD'):"$"::string       as "ScheduledPurchasesInTD",
xmlget(value, 'AnnouncementPDFName'):"$"::string          as "AnnouncementPDFName",
xmlget(value, 'OriginalDatedDate'):"$"::string            as "OriginalDatedDate",
xmlget(value, 'AdjustedAmountCurrentlyOutstanding'):"$"::string as "AdjustedAmountCurrentlyOutstanding",
xmlget(value, 'NLPExclusionAmount'):"$"::string           as "NLPExclusionAmount",
xmlget(value, 'MaximumNonCompAward'):"$"::string          as "MaximumNonCompAward",
xmlget(value, 'AdjustedAccruedInterest'):"$"::string      as "AdjustedAccruedInterest"
from testdb.test_schema.xml_employee, lateral flatten(to_array(xml_data : "$"));

-- from xml_employee, lateral flatten(input => xml_data);

select * from testdb.test_schema.auction_data;

