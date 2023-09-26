Include webimport

IncludeGenerator webimport

Class web.PACLocationInjury Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM = "LOCINJ_DateFrom";

Parameter SQLDATETO = "LOCINJ_DateTo";

Parameter SQLCODE = "LOCINJ_Code";

Parameter SQLDESCRIPTION = "LOCINJ_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((LOCINJ_DateFrom <= CURRENT_DATE OR LOCINJ_DateFrom IS NULL) AND (LOCINJ_DateTo >= CURRENT_DATE OR LOCINJ_DateTo IS NULL))";

Parameter SQLROWID = "LOCINJ_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "LOCINJDesc,LOCINJCode,HIDDEN")
{
	SELECT	LOCINJ_Desc,LOCINJ_Code,LOCINJ_RowID
	FROM	SQLUser.PAC_LocationInjury
	WHERE	((LOCINJ_Desc %STARTSWITH :desc) OR (LOCINJ_Code = :desc))
	AND	((LOCINJ_DateFrom IS NULL) OR (LOCINJ_DateFrom<= :date))
	AND	((LOCINJ_DateTo IS NULL) OR (LOCINJ_DateTo>= :date))
	ORDER	BY LOCINJ_Desc
}

}
