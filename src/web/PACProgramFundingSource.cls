Class web.PACProgramFundingSource Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLCODE = "PFS_Code";

Parameter SQLDATEFROM = "PFS_DateFrom";

Parameter SQLDATETO = "PFS_DateTo";

Parameter SQLDESCRIPTION = "PFS_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PFS_DateFrom <= CURRENT_DATE OR PFS_DateFrom IS NULL) AND (PFS_DateTo >= CURRENT_DATE OR PFS_DateTo IS NULL))";

Parameter SQLROWID = "PFS_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpActive(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PFSDesc,PFSCode,HIDDEN")
{
SELECT PFS_Desc,PFS_Code,PFS_RowID
FROM 	SQLUser.PAC_ProgramFundingSource
WHERE ((PFS_Desc %STARTSWITH :desc) OR (%ALPHAUP PFS_Code = %ALPHAUP :desc))
ORDER BY 	PFS_Desc
}

}
