Include webimport

IncludeGenerator webimport

Class web.PACPatientRoleRA Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM = "PATROL_DateFrom";

Parameter SQLDATETO = "PATROL_DateTo";

Parameter SQLCODE = "PATROL_Code";

Parameter SQLDESCRIPTION = "PATROL_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PATROL_DateFrom <= CURRENT_DATE OR PATROL_DateFrom IS NULL) AND (PATROL_DateTo >= CURRENT_DATE OR PATROL_DateTo IS NULL))";

Parameter SQLROWID = "PATROL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PATROLDesc,PATROLCode,HIDDEN")
{
	SELECT	PATROL_Desc,PATROL_Code,PATROL_RowID
	FROM	SQLUser.PAC_PatientRoleRA
	WHERE	((PATROL_Desc %STARTSWITH :desc) OR (PATROL_Code = :desc))
	AND	((PATROL_DateFrom IS NULL) OR (PATROL_DateFrom<= :date))
	AND	((PATROL_DateTo IS NULL) OR (PATROL_DateTo>= :date))
	ORDER	BY PATROL_Desc
}

}
