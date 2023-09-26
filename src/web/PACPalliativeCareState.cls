Class web.PACPalliativeCareState Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWithScore(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "PCS_Code";

Parameter SQLDATEFROM = "PCS_DateFrom";

Parameter SQLDATETO = "PCS_DateTo";

Parameter SQLDESCRIPTION = "PCS_Desc";

Parameter SQLROWID = "PCS_RowId";

Query LookUpWithScore(Desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT  PCS_Desc,PCS_Code,PCS_NumericVal
FROM SQLUser.PAC_PalliativeCareState
WHERE ((PCS_Desc %STARTSWITH :Desc) OR (PCS_Code %STARTSWITH :Desc))
ORDER BY PCS_Desc
}

}
