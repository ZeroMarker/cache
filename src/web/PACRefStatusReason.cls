Class web.PACRefStatusReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

Parameter SQLCODE = "REFSTREA_Code";

Parameter SQLDATEFROM = "REFSTREA_DateFrom";

Parameter SQLDATETO = "REFSTREA_DateTo";

Parameter SQLDESCRIPTION = "REFSTREA_Desc";

Parameter SQLROWID = "REFSTREA_RowId";

Property dummy As %String(TRUNCATE = 1);

}
