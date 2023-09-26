Class web.MRCTumorType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM = "TUMT_DateFrom";

Parameter SQLDATETO = "TUMT_DateTo";

Parameter SQLCODE = "TUMT_Code";

Parameter SQLDESCRIPTION = "TUMT_Desc";

Parameter SQLROWID = "TUMT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "TUMTDesc,TUMTCode,HIDDEN")
{
	SELECT	TUMT_Desc,TUMT_Code,TUMT_RowID
	FROM	SQLUser.MRC_TumorType
	WHERE	((TUMT_Desc %STARTSWITH :desc) OR (TUMT_Code = :desc))
	AND	((TUMT_DateFrom IS NULL) OR (TUMT_DateFrom<= :date))
	AND	((TUMT_DateTo IS NULL) OR (TUMT_DateTo>= :date))
	ORDER	BY TUMT_Desc
}

}
