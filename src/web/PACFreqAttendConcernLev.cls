Class web.PACFreqAttendConcernLev Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 3;

Parameter SQLCODE = "FCL_Code";

Parameter SQLDATEFROM = "FCL_DateFrom";

Parameter SQLDATETO = "FCL_DateTo";

Parameter SQLDESCRIPTION = "FCL_Desc";

Parameter SQLROWID = "FCL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
