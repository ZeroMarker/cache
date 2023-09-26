Class web.PACHistOfDeliv Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM = "HISTD_DateFrom";

Parameter SQLDATETO = "HISTD_DateTo";

Parameter SQLCODE = "HISTD_Code";

Parameter SQLDESCRIPTION = "HISTD_Desc";

Parameter SQLROWID = "HISTD_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "HISTDDesc,HISTDCode,HIDDEN")
{
	SELECT	HISTD_Desc,HISTD_Code,HISTD_RowID
	FROM	SQLUser.PAC_HistOfDeliv
	WHERE	((HISTD_Desc %STARTSWITH :desc) OR (HISTD_Code = :desc))
	AND	((HISTD_DateFrom IS NULL) OR (HISTD_DateFrom<= :date))
	AND	((HISTD_DateTo IS NULL) OR (HISTD_DateTo>= :date))
	ORDER	BY HISTD_Desc
}

}
