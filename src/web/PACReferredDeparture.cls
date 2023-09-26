Include webimport

IncludeGenerator webimport

Class web.PACReferredDeparture Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM = "REFDEP_DateFrom";

Parameter SQLDATETO = "REFDEP_DateTo";

Parameter SQLCODE = "REFDEP_Code";

Parameter SQLDESCRIPTION = "REFDEP_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((REFDEP_DateFrom <= CURRENT_DATE OR REFDEP_DateFrom IS NULL) AND (REFDEP_DateTo >= CURRENT_DATE OR REFDEP_DateTo IS NULL))";

Parameter SQLROWID = "REFDEP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT REFDEP_Desc,REFDEP_RowID,REFDEP_Code
FROM SQLUser.PAC_ReferredDeparture
WHERE ((%ALPHAUP REFDEP_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP REFDEP_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((REFDEP_DateFrom <= :date OR REFDEP_DateFrom IS NULL) AND  (REFDEP_DateTo IS NULL OR REFDEP_DateTo >= :date)))
ORDER   BY REFDEP_Desc
}

ClassMethod LookUpBrokerWithDateNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDateNC(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT REFDEP_Desc,REFDEP_RowID,REFDEP_Code,REFDEP_NationalCode
FROM SQLUser.PAC_ReferredDeparture
WHERE ((%ALPHAUP REFDEP_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP REFDEP_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((REFDEP_DateFrom <= :date OR REFDEP_DateFrom IS NULL) AND  (REFDEP_DateTo IS NULL OR REFDEP_DateTo >= :date)))
ORDER   BY REFDEP_Desc
}

}
