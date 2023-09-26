Class web.PACEmploymentStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLDATEFROM = "EMPLST_DateFrom";

Parameter SQLDATETO = "EMPLST_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "EMPLST_Code";

Parameter SQLDESCRIPTION = "EMPLST_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((EMPLST_DateFrom <= CURRENT_DATE OR EMPLST_DateFrom IS NULL) AND (EMPLST_DateTo >= CURRENT_DATE OR EMPLST_DateTo IS NULL))";

Parameter SQLROWID = "EMPLST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "EMPLSTDesc,EMPLSTCode,HIDDEN")
{
	SELECT	EMPLST_Desc,EMPLST_Code,EMPLST_RowID
	FROM	SQLUser.PAC_EmploymentStatus
	WHERE	((EMPLST_Desc %STARTSWITH :desc) OR (EMPLST_Code = :desc))
	AND	((EMPLST_DateFrom IS NULL) OR (EMPLST_DateFrom<= :date))
	AND	((EMPLST_DateTo IS NULL) OR (EMPLST_DateTo>= :date))
	ORDER	BY EMPLST_Desc
}

}
