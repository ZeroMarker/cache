Class web.PACLeaveType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM = "LEATYP_DateFrom";

Parameter SQLDATETO = "LEATYP_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LEATYP_Code";

Parameter SQLDESCRIPTION = "LEATYP_Desc";

Parameter SQLROWID = "LEATYP_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT LEATYP_Desc,LEATYP_RowID,LEATYP_Code
FROM SQLUser.PAC_LeaveType
WHERE ((%ALPHAUP LEATYP_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP LEATYP_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((LEATYP_DateFrom <= :date OR LEATYP_DateFrom IS NULL) AND  (LEATYP_DateTo IS NULL OR LEATYP_DateTo >= :date)))
ORDER   BY LEATYP_Desc
}

}
