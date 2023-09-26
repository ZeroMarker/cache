Class web.MRCSeverity Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLCODE = "SEV_Code";

Parameter SQLDATEFROM = "SEV_DateFrom";

Parameter SQLDATETO = "SEV_DateTo";

Parameter SQLDESCRIPTION = "SEV_Desc";

Parameter SQLROWID = "SEV_RowId";

Query LookUpForListBox() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Code,Desc")
{
	SELECT	SEV_Code,SEV_Desc
	FROM	SQLUser.MRC_Severity
	ORDER	BY SEV_Desc
}

}
