Include webimport

IncludeGenerator webimport

Class web.MRCBodySystemProbStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

Parameter SQLDATEFROM = "STAT_DateFrom";

Parameter SQLDATETO = "STAT_DateTo";

Parameter SQLCODE = "STAT_Code";

Parameter SQLDESCRIPTION = "STAT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((STAT_DateFrom <= CURRENT_DATE OR STAT_DateFrom IS NULL) AND (STAT_DateTo >= CURRENT_DATE OR STAT_DateTo IS NULL))";

Parameter SQLROWID = "STAT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

/// log 62402
ClassMethod LookUpBodyProblemBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT STAT_Desc,STAT_RowID,STAT_Code
FROM SQLUser.MRC_BodySystemProbStatus
WHERE ((%ALPHAUP STAT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP STAT_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((STAT_DateFrom <= :date OR STAT_DateFrom IS NULL) AND  (STAT_DateTo IS NULL OR STAT_DateTo >= :date)))
ORDER   BY STAT_Desc
}

}
