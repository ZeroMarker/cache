Include webimport

IncludeGenerator webimport

Class web.PACTrafAccidCode Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Parameter SQLDATEFROM = "TRF_DateFrom";

Parameter SQLDATETO = "TRF_DateTo";

Parameter SQLCODE = "TRF_Code";

Parameter SQLDESCRIPTION = "TRF_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((TRF_DateFrom <= CURRENT_DATE OR TRF_DateFrom IS NULL) AND (TRF_DateTo >= CURRENT_DATE OR TRF_DateTo IS NULL))";

Parameter SQLROWID = "TRF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "TRFDesc,TRFCode,HIDDEN")
{
	SELECT	TRF_Desc,TRF_Code,TRF_RowID
	FROM	SQLUser.PAC_TrafAccidCode
	WHERE	((TRF_Desc %STARTSWITH :desc) OR (TRF_Code = :desc))
	AND	((TRF_DateFrom IS NULL) OR (TRF_DateFrom<= :date))
	AND	((TRF_DateTo IS NULL) OR (TRF_DateTo>= :date))
	ORDER	BY TRF_Desc
}

}
