Class web.ORCReasonForSuspend Extends (%Library.Persistent, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 22;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SUSP_Code";

Parameter SQLDESCRIPTION = "SUSP_Desc";

Parameter SQLROWID = "SUSP_RowId";

}
