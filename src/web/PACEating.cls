Class web.PACEating Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWithScore(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "EAT_Code";

Parameter SQLDATEFROM = "EAT_DateFrom";

Parameter SQLDATETO = "EAT_DateTo";

Parameter SQLDESCRIPTION = "EAT_Desc";

Parameter SQLROWID = "EAT_RowId";

Query LookUpWithScore(Desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT  EAT_Desc,EAT_Code,EAT_NumericVal
FROM SQLUser.PAC_Eating
WHERE ((EAT_Desc %STARTSWITH :Desc) OR (EAT_Code %STARTSWITH :Desc))
ORDER BY EAT_Desc
}

}
