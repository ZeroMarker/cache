Class web.PACFundingArrangement Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLCODE = "FUNDAR_Code";

Parameter SQLDATEFROM = "FUNDAR_DateFrom";

Parameter SQLDATETO = "FUNDAR_DateTo";

Parameter SQLDESCRIPTION = "FUNDAR_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((FUNDAR_DateFrom <= CURRENT_DATE OR FUNDAR_DateFrom IS NULL) AND (FUNDAR_DateTo >= CURRENT_DATE OR FUNDAR_DateTo IS NULL))";

Parameter SQLROWID = "FUNDAR_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpActive(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "FUNDARDesc,FUNDARCode,HIDDEN")
{
SELECT FUNDAR_Desc,FUNDAR_Code,FUNDAR_RowID
FROM 	SQLUser.PAC_FundingArrangement
WHERE ((FUNDAR_Desc %STARTSWITH :desc) OR (%ALPHAUP FUNDAR_Code = %ALPHAUP :desc))
ORDER BY 	FUNDAR_Desc
}

}
