Class web.PACCustomExtractReport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCode(ExtractType As %Library.String, Code As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpReportBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", extract As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "REP_Code";

Parameter SQLDESCRIPTION = "REP_Desc";

Parameter SQLROWID = "REP_RowId";

Query Find(desc As %Library.String, ExtractType As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "code,description")
{
SELECT REP_Code, REP_Desc
FROM SQLUser.PAC_CustomExtractReport
WHERE ((%ALPHAUP REP_Code %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP REP_Desc %STARTSWITH %ALPHAUP :desc))
AND (((REP_ParRef->CUSTEXT_Desc=:ExtractType) OR (REP_ParRef->CUSTEXT_Desc IS NULL)) OR (:ExtractType IS NULL))
}

}
