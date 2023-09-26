Include webimport

IncludeGenerator webimport

Class web.ARCPayorContactType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM = "PCT_DateFrom";

Parameter SQLDATETO = "PCT_DateTo";

Parameter SQLCODE = "PCT_Code";

Parameter SQLDESCRIPTION = "PCT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PCT_DateFrom <= CURRENT_DATE OR PCT_DateFrom IS NULL) AND (PCT_DateTo >= CURRENT_DATE OR PCT_DateTo IS NULL))";

Parameter SQLROWID = "PCT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PCTDesc,HIDDEN,PCTCode")
{
	SELECT	PCT_Desc,PCT_RowID,PCT_Code
	FROM	SQLUser.ARC_PayorContactType
	WHERE	((PCT_Desc %STARTSWITH :desc) OR (PCT_Code = :desc))
	AND	((PCT_DateFrom IS NULL) OR (PCT_DateFrom<= :date))
	AND	((PCT_DateTo IS NULL) OR (PCT_DateTo>= :date))
	ORDER	BY PCT_Desc
}

}
