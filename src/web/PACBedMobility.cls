Class web.PACBedMobility Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWithScore(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "BM_Code";

Parameter SQLDATEFROM = "BM_DateFrom";

Parameter SQLDATETO = "BM_DateTo";

Parameter SQLDESCRIPTION = "BM_Desc";

Parameter SQLROWID = "BM_RowId";

Query LookUpWithScore(Desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT  BM_Desc,BM_Code,BM_NumericVal
FROM SQLUser.PAC_BedMobility
WHERE ((BM_Desc %STARTSWITH :Desc) OR (BM_Code %STARTSWITH :Desc))
ORDER BY BM_Desc
}

}
