Class web.PACIntentionReadmit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "INTREA_Code";

Parameter SQLDATEFROM = "INTREA_DateFrom";

Parameter SQLDATETO = "INTREA_DateTo";

Parameter SQLDESCRIPTION = "INTREA_Desc";

Parameter SQLROWID = "INTREA_RowId";

Query LookUpActive(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN,INTREACode,INTREADesc")
{
SELECT INTREA_RowID, INTREA_Code, INTREA_Desc
FROM 	SQLUser.PAC_IntentionReadmit
WHERE ((INTREA_Desc %STARTSWITH :desc) OR (INTREA_Code = :desc))
ORDER BY 	INTREA_Desc
}

}
