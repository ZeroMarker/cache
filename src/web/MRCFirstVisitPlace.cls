Class web.MRCFirstVisitPlace Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM = "FVP_DateFrom";

Parameter SQLDATETO = "FVP_DateTo";

Parameter SQLCODE = "FVP_Code";

Parameter SQLDESCRIPTION = "FVP_Desc";

Parameter SQLROWID = "FVP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "FVPDesc,FVPCode,HIDDEN")
{
	SELECT	FVP_Desc,FVP_Code,FVP_RowID
	FROM	SQLUser.MRC_FirstVisitPlace
	WHERE	((FVP_Desc %STARTSWITH :desc) OR (FVP_Code = :desc))
	AND	((FVP_DateFrom IS NULL) OR (FVP_DateFrom<= :date))
	AND	((FVP_DateTo IS NULL) OR (FVP_DateTo>= :date))
	ORDER	BY FVP_Desc
}

}
