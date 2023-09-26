Class web.PACWIESVersion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod GetCurrentVersion() As %Library.String
{
}

ClassMethod LookUpByCodeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "WIESV_Code";

Parameter SQLDATEFROM = "WIESV_DateFrom";

Parameter SQLDATETO = "WIESV_DateTo";

Parameter SQLDESCRIPTION = "WIESV_RowId";

Parameter SQLROWID = "WIESV_RowId";

/// KK 21/11/2002 Log 28512 Lookup to get code
Query LookUpByCode(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Code:%String,HIDDEN:%String,Description:%String")
{
SELECT WIESV_Code, WIESV_RowId, WIESV_Desc
FROM SQLUser.PAC_WIESVersion
WHERE ((WIESV_Code %STARTSWITH :desc) OR (WIESV_Desc %STARTSWITH :desc))
}

}
