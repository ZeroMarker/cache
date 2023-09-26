Class web.OECToothArea Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TOOTHA_Code";

Parameter SQLDESCRIPTION = "TOOTHA_Desc";

Parameter SQLROWID = "TOOTHA_RowId";

Property dummy As %String(TRUNCATE = 1);

}
