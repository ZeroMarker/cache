Include webimport

IncludeGenerator webimport

Class web.MRCDiagnosSignSymptom Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "DSYM_Code";

Parameter SQLDATEFROM = "DSYM_DateFrom";

Parameter SQLDATETO = "DSYM_DateTo";

Parameter SQLDESCRIPTION = "DSYM_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((DSYM_DateFrom <= CURRENT_DATE OR DSYM_DateFrom IS NULL) AND (DSYM_DateTo >= CURRENT_DATE OR DSYM_DateTo IS NULL)) AND (DSYM_ActiveInActive IS NULL)";

Parameter SQLROWID = "DSYM_RowId";

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSYMCode:%String,DSYMDesc:%String")
{
SELECT DSYM_RowId, DSYM_Code, DSYM_Desc
FROM MRC_DiagnosSignSymptom
WHERE DSYM_RowId = :ID
ORDER BY DSYM_Code
}

Query Find(Code As %String, Desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSYMCode:%String,DSYMDesc:%String")
{
SELECT DSYM_RowId, DSYM_Code, DSYM_Desc
FROM MRC_DiagnosSignSymptom
WHERE (DSYM_Code %STARTSWITH :Code) AND (DSYM_Desc %STARTSWITH :Desc)
ORDER BY DSYM_Code
}

Query LookUpByConsult(ConsultID As %String, val As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpByConsultClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByConsultFetch ]
{
}

/// ab 13.09.06 60406 -restrict to only those ICD's against consult - using DIAGCons index
ClassMethod LookUpByConsultExecute(ByRef QHandle As %Library.Binary, ConsultID As %Library.String, val As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByConsultFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByConsultExecute ]
{
}

ClassMethod LookUpByConsultBroker(itmjs As %String = "", itmjsex As %String = "", ConsultID As %String = "", val As %String = "") As %Boolean
{
}

}
