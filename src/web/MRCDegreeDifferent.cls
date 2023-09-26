Class web.MRCDegreeDifferent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM = "DEGDIF_DateFrom";

Parameter SQLDATETO = "DEGDIF_DateTo";

Parameter SQLCODE = "DEGDIF_Code";

Parameter SQLDESCRIPTION = "DEGDIF_Desc";

Parameter SQLROWID = "DEGDIF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "DEGDIFDesc,DEGDIFCode,HIDDEN")
{
	SELECT	DEGDIF_Desc,DEGDIF_Code,DEGDIF_RowID
	FROM	SQLUser.MRC_DegreeDifferent
	WHERE	((DEGDIF_Desc %STARTSWITH :desc) OR (DEGDIF_Code = :desc))
	AND	((DEGDIF_DateFrom IS NULL) OR (DEGDIF_DateFrom<= :date))
	AND	((DEGDIF_DateTo IS NULL) OR (DEGDIF_DateTo>= :date))
	ORDER	BY DEGDIF_Desc
}

}
