Class web.MRCHistoryOfTreatment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM = "HOT_DateFrom";

Parameter SQLDATETO = "HOT_DateTo";

Parameter SQLCODE = "HOT_Code";

Parameter SQLDESCRIPTION = "HOT_Desc";

Parameter SQLROWID = "HOT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "HOTDesc,HOTCode,HIDDEN")
{
	SELECT	HOT_Desc,HOT_Code,HOT_RowID
	FROM	SQLUser.MRC_HistoryOfTreatment
	WHERE	((HOT_Desc %STARTSWITH :desc) OR (HOT_Code = :desc))
	AND	((HOT_DateFrom IS NULL) OR (HOT_DateFrom<= :date))
	AND	((HOT_DateTo IS NULL) OR (HOT_DateTo>= :date))
	ORDER	BY HOT_Desc
}

}
