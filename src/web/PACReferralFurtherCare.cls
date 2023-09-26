Class web.PACReferralFurtherCare Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM = "RFCARE_DateFrom";

Parameter SQLDATETO = "RFCARE_DateTo";

Parameter SQLCODE = "RFCARE_Code";

Parameter SQLDESCRIPTION = "RFCARE_Desc";

Parameter SQLROWID = "RFCARE_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RFCAREDesc,RFCARECode,HIDDEN")
{
	SELECT	RFCARE_Desc,RFCARE_Code,RFCARE_RowID
	FROM	SQLUser.PAC_ReferralFurtherCare
	WHERE	((RFCARE_Desc %STARTSWITH :desc) OR (RFCARE_Code = :desc))
	AND	((RFCARE_DateFrom IS NULL) OR (RFCARE_DateFrom<= :date))
	AND	((RFCARE_DateTo IS NULL) OR (RFCARE_DateTo>= :date))
	ORDER	BY RFCARE_Desc
}

}
