Class web.PACLaterality Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 41;

Parameter SQLDATEFROM = "LATER_DateFrom";

Parameter SQLDATETO = "LATER_DateTo";

Parameter SQLCODE = "LATER_Code";

Parameter SQLDESCRIPTION = "LATER_Desc";

Parameter SQLROWID = "LATER_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Returns the description passing the code value.
ClassMethod GetDescriptionFromCode(code As %String) As %String
{
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "LATERDesc,LATERCode,HIDDEN")
{
	SELECT	LATER_Desc,LATER_Code,LATER_RowID
	FROM	SQLUser.PAC_Laterality
	WHERE	((LATER_Desc %STARTSWITH :desc) OR (LATER_Code = :desc))
	AND	((LATER_DateFrom IS NULL) OR (LATER_DateFrom<= :date))
	AND	((LATER_DateTo IS NULL) OR (LATER_DateTo>= :date))
	ORDER	BY LATER_Desc
}

Query LookUpForListBox() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "LATERCode,LATERDesc")
{
	SELECT	LATER_Code,LATER_Desc
	FROM	SQLUser.PAC_Laterality
	ORDER	BY LATER_Desc
}

}
