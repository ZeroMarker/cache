Include webimport

IncludeGenerator webimport

Class web.PACTransferring Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM = "TRANSF_DateFrom";

Parameter SQLDATETO = "TRANSF_DateTo";

Parameter SQLCODE = "TRANSF_Code";

Parameter SQLDESCRIPTION = "TRANSF_Desc";

Parameter SQLROWID = "TRANSF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWithScore(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithScore(Desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT  TRANSF_Desc,TRANSF_Code,TRANSF_NumericVal
FROM SQLUser.PAC_Transferring
WHERE ((TRANSF_Desc %STARTSWITH :Desc) OR (TRANSF_Code %STARTSWITH :Desc))
ORDER BY TRANSF_Desc
}

}
