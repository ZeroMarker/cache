Class web.PACToileting Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
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

Parameter SQLCODE = "TOIL_Code";

Parameter SQLDATEFROM = "TOIL_DateFrom";

Parameter SQLDATETO = "TOIL_DateTo";

Parameter SQLDESCRIPTION = "TOIL_Desc";

Parameter SQLROWID = "TOIL_RowId";

Query LookUpWithScore(Desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT  TOIL_Desc,TOIL_Code,TOIL_NumericVal
FROM SQLUser.PAC_Toileting
WHERE ((TOIL_Desc %STARTSWITH :Desc) OR (TOIL_Code %STARTSWITH :Desc))
ORDER BY TOIL_Desc
}

}
