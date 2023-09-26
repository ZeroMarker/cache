Class web.OECResultEscalation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ESC_Code";

Parameter SQLDESCRIPTION = "ESC_Desc";

Parameter SQLROWID = "ESC_RowId";

Property dummy As %String(TRUNCATE = 1);

}
