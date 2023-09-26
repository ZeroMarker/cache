Include webimport

IncludeGenerator webimport

Class web.PACReferralPeriod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

Parameter SQLDATEFROM = "REFPER_DateFrom";

Parameter SQLDATETO = "REFPER_DateTo";

Parameter SQLCODE = "REFPER_Code";

Parameter SQLDESCRIPTION = "REFPER_Desc";

Parameter SQLROWID = "REFPER_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpFactorBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithFactor(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "code:%String,HIDDEN:%String,desc:%String,HIDDEN:%String")
{
SELECT REFPER_Code,REFPER_RowId,REFPER_Desc, REFPER_Factor
FROM SQLUser.PAC_ReferralPeriod
WHERE (REFPER_Desc %STARTSWITH :desc) OR (REFPER_Code %STARTSWITH :desc)
ORDER BY REFPER_Desc
}

}
