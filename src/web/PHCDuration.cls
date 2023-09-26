Include webimport

IncludeGenerator webimport

Class web.PHCDuration Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 113;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerDuration(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "PHCDU_Code";

Parameter SQLDESCRIPTION = "PHCDU_Desc1";

Parameter SQLROWID = "PHCDU_RowId";

Query LookUpDuration(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "CTPCPDesc,CTPCPCode,HIDDEN:%String")
{
SELECT PHCDU_Desc1, PHCDU_Code, PHCDU_Factor
FROM PHC_Duration
WHERE   PHCDU_Desc1  %STARTSWITH  :desc
ORDER   BY PHCDU_Desc1
}

/// log 63684
ClassMethod GetDurationLookupResult(PHCDUDesc As %Library.String = "") As %Library.String
{
}

}
