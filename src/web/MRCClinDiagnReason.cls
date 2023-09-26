Class web.MRCClinDiagnReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM = "CLDR_DateFrom";

Parameter SQLDATETO = "CLDR_DateTo";

Parameter SQLCODE = "CLDR_Code";

Parameter SQLDESCRIPTION = "CLDR_Desc";

Parameter SQLROWID = "CLDR_RowId";

/// Log 39212 - AI - 22-09-2003 : Added filter to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CLDR_DateFrom <= CURRENT_DATE OR CLDR_DateFrom IS NULL) AND (CLDR_DateTo >= CURRENT_DATE OR CLDR_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

/// AJI 30.10.03 log 35869 - broker needed to get the "TextRequired" column
ClassMethod LookUpClinDiagReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

/// AJI 30.10.03 log 35869 - a new lookup query needed to get the "TextRequired" column
Query LookUpClinDiagReason(desc As %Library.String, date As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
SELECT CLDR_Desc,CLDR_Code,CLDR_TextRequired
FROM SQLUser.MRC_ClinDiagnReason
WHERE (%ALPHAUP CLDR_Desc [%ALPHAUP  :desc)
AND ((CLDR_DateFrom <= CURRENT_DATE OR CLDR_DateFrom IS NULL) AND (CLDR_DateTo >= CURRENT_DATE OR CLDR_DateTo IS NULL))
ORDER   BY CLDR_Desc
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT	CLDR_Desc,CLDR_Code,CLDR_TextRequired,CLDR_RowId
	FROM	SQLUser.MRC_ClinDiagnReason
	WHERE	((CLDR_Desc %STARTSWITH :desc) OR (CLDR_Code = :desc))
	AND	((CLDR_DateFrom IS NULL) OR (CLDR_DateFrom<= :date))
	AND	((CLDR_DateTo IS NULL) OR (CLDR_DateTo>= :date))
	ORDER	BY CLDR_Desc
}

}
