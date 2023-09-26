Class web.PACTraceOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRACE_Code";

Parameter SQLDESCRIPTION = "TRACE_Desc";

Parameter SQLROWID = "TRACE_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpByDescription(TraceDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "TraceDesc,Code")
{
select distinct ST_TraceOutcome_DR->TRACE_Desc, ST_TraceOutcome_DR->TRACE_Code
from SQLUser.PAC_TraceOutcomeStatus
where ST_ParRef->TRACE_Desc=:TraceDesc
}

Query LookUpByName(TraceCode As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "TraceCode,Desc")
{
select distinct ST_TraceOutcome_DR->TRACE_Code, ST_TraceOutcome_DR->TRACE_Desc
from SQLUser.PAC_TraceOutcomeStatus
where ST_ParRef->TRACE_Code=:TraceCode
}

}
