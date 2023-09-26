Class web.MRCDegreeProgression Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM = "DEGPRO_DateFrom";

Parameter SQLDATETO = "DEGPRO_DateTo";

Parameter SQLCODE = "DEGPRO_Code";

Parameter SQLDESCRIPTION = "DEGPRO_Desc";

Parameter SQLROWID = "DEGPRO_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "DEGPRODesc,DEGPROCode,HIDDEN")
{
	SELECT	DEGPRO_Desc,DEGPRO_Code,DEGPRO_RowID
	FROM	SQLUser.MRC_DegreeProgression
	WHERE	((DEGPRO_Desc %STARTSWITH :desc) OR (DEGPRO_Code = :desc))
	AND	((DEGPRO_DateFrom IS NULL) OR (DEGPRO_DateFrom<= :date))
	AND	((DEGPRO_DateTo IS NULL) OR (DEGPRO_DateTo>= :date))
	ORDER	BY DEGPRO_Desc
}

}
