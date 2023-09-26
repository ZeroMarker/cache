Include webimport

IncludeGenerator webimport

Class web.MRCDiagnosStatus Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DSTAT_Code";

Parameter SQLDESCRIPTION = "DSTAT_Desc";

Parameter SQLROWID = "DSTAT_RowId";

Property dummy As %String(TRUNCATE = 1);

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSTATCode:%String,DSTATDesc:%String")
{
SELECT DSTAT_RowId, DSTAT_Code, DSTAT_Desc
FROM MRC_DiagnosStatus
WHERE DSTAT_RowId = :ID
ORDER BY DSTAT_Code
}

Query Find(Code As %String, Desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSTATCode:%String,DSTATDesc:%String")
{
SELECT DSTAT_RowId, DSTAT_Code, DSTAT_Desc
FROM MRC_DiagnosStatus
WHERE (DSTAT_Code %STARTSWITH :Code) AND (DSTAT_Desc %STARTSWITH :Desc)
ORDER BY DSTAT_Code
}

}
