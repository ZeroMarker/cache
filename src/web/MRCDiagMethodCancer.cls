Class web.MRCDiagMethodCancer Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Parameter SQLDATEFROM = "DMOC_DateFrom";

Parameter SQLDATETO = "DMOC_DateTo";

Parameter SQLCODE = "DMOC_Code";

Parameter SQLDESCRIPTION = "DMOC_Desc";

Parameter SQLROWID = "DMOC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerMethCancer(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpByCodeOrDesc(val As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MethodDesc,MethodCode,HIDDEN")
{
	SELECT	  DMOC_Desc,DMOC_Code,DMOC_Clinical
	FROM	  SQLUser.MRC_DiagMethodCancer
	WHERE	  ((DMOC_Desc %STARTSWITH :val) OR (DMOC_Code= :val))
	AND		  ((DMOC_DateFrom <= CURRENT_DATE) OR (DMOC_DateFrom IS NULL)) 
	AND 	  ((DMOC_DateTo >= CURRENT_DATE) OR (DMOC_DateTo IS NULL))
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "MethodDesc,MethodCode,HIDDEN")
{
	SELECT	DMOC_Desc,DMOC_Code,DMOC_Clinical
	FROM	SQLUser.MRC_DiagMethodCancer
	WHERE	((DMOC_Desc %STARTSWITH :desc) OR (DMOC_Code = :desc))
	AND	((DMOC_DateFrom IS NULL) OR (DMOC_DateFrom<= :date))
	AND	((DMOC_DateTo IS NULL) OR (DMOC_DateTo>= :date))
	ORDER	BY DMOC_Desc
}

}
