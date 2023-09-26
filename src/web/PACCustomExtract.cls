Include webimport

IncludeGenerator webimport

Class web.PACCustomExtract Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCode(Code As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpExtractBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "CUSTEXT_Code";

Parameter SQLDESCRIPTION = "CUSTEXT_Desc";

Parameter SQLROWID = "CUSTEXT_RowId";

Query LookUpExtract() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description,Code")
{
SELECT CUSTEXT_Desc, CUSTEXT_Code
FROM SQLUser.PAC_CustomExtract
}

}
