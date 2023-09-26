Class web.PACPensionStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM = "PENST_DateFrom";

Parameter SQLDATETO = "PENST_DateTo";

Parameter SQLCODE = "PENST_Code";

Parameter SQLDESCRIPTION = "PENST_Desc";

Parameter SQLROWID = "PENST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PENSTDesc,PENSTCode,HIDDEN")
{
	SELECT	PENST_Desc,PENST_Code,PENST_RowID
	FROM	SQLUser.PAC_PensionStatus
	WHERE	((PENST_Desc %STARTSWITH :desc) OR (PENST_Code = :desc))
	AND	((PENST_DateFrom IS NULL) OR (PENST_DateFrom<= :date))
	AND	((PENST_DateTo IS NULL) OR (PENST_DateTo>= :date))
	ORDER	BY PENST_Desc
}

}
