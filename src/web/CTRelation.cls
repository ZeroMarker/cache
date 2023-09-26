Include webimport

IncludeGenerator webimport

Class web.CTRelation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 106;

Parameter SQLDATEFROM = "CTRLT_DateFrom";

Parameter SQLDATETO = "CTRLT_DateTo";

Parameter SQLCODE = "CTRLT_Code";

Parameter SQLDESCRIPTION = "CTRLT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTRLT_DateFrom <= CURRENT_DATE OR CTRLT_DateFrom IS NULL) AND (CTRLT_DateTo >= CURRENT_DATE OR CTRLT_DateTo IS NULL))";

Parameter SQLROWID = "CTRLT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CTRLTDesc,CTRLTCode,HIDDEN")
{
	SELECT	CTRLT_Desc,CTRLT_Code,CTRLT_RowID
	FROM	SQLUser.CT_Relation
	WHERE	((CTRLT_Desc %STARTSWITH :desc) OR (CTRLT_Code = :desc))
	AND	((CTRLT_DateFrom IS NULL) OR (CTRLT_DateFrom<= :date))
	AND	((CTRLT_DateTo IS NULL) OR (CTRLT_DateTo>= :date))
	ORDER	BY CTRLT_Desc
}

Query LookUpList() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CTRLTCode,CTRLTDesc,HIDDEN")
{
	SELECT	CTRLT_Code,CTRLT_Desc,CTRLT_RowID
	FROM	SQLUser.CT_Relation
	WHERE((CTRLT_DateFrom IS NULL) OR (CTRLT_DateFrom<= CURRENT_DATE))
	AND	((CTRLT_DateTo IS NULL) OR (CTRLT_DateTo>= CURRENT_DATE))
	ORDER	BY CTRLT_Desc
}

}
