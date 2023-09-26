Class web.PACSourceOfAddition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Property Dummy As %Library.String(TRUNCATE = 1);

/// rqg/Log24184: To return the source of addition code if description is passed.
ClassMethod GetCodeFromDescription(desc As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBySourceBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpSourceBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "SADD_Code";

Parameter SQLDATEFROM = "SADD_DateFrom";

Parameter SQLDATETO = "SADD_DateTo";

Parameter SQLDESCRIPTION = "SADD_Desc";

Parameter SQLROWID = "SADD_RowId";

Query LookUpBySource(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,hidden:%String,code:%String")
{
SELECT SADD_Desc,SADD_RowId,SADD_Code
FROM SQLUser.PAC_SourceOfAddition
WHERE ((%UPPER SADD_Desc %STARTSWITH %UPPER :val) OR (%UPPER SADD_Code %STARTSWITH %UPPER :val))
AND ((SADD_DateFrom <= :activedate) OR (SADD_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((SADD_DateTo >= :activedate) OR (SADD_DateTo IS NULL) OR (:activedate IS NULL))
}

Query LookUpSource(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
SELECT SADD_Desc,SADD_Code
FROM SQLUser.PAC_SourceOfAddition
WHERE (%ALPHAUP SADD_Desc [%ALPHAUP :desc) OR (%ALPHAUP SADD_Code [%ALPHAUP :desc)
ORDER BY SADD_Desc
}

}
