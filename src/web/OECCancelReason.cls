Class web.OECCancelReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLROWID = "CANCREA_RowId";

Parameter SQLCODE = "CANCREA_Code";

Parameter SQLDESCRIPTION = "CANCREA_Desc";

Property dummy As %String(TRUNCATE = 1);

}
