Class web.PACBillingMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLCODE = "BLM_Code";

Parameter SQLDATEFROM = "BLM_DateFrom";

Parameter SQLDATETO = "BLM_DateTo";

Parameter SQLDESCRIPTION = "BLM_Desc";

Parameter SQLROWID = "BLM_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpActive(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "BLMDesc,BLMCode,HIDDEN")
{
SELECT BLM_Desc, BLM_Code, BLM_RowID
FROM 	SQLUser.PAC_BillingMethod
WHERE ((BLM_Desc %STARTSWITH :desc) OR (BLM_Code = :desc))
ORDER BY 	BLM_Desc
}

}
