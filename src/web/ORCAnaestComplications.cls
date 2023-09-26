Class web.ORCAnaestComplications Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANACOM_Code";

Parameter SQLDESCRIPTION = "ANACOM_Desc";

Parameter SQLROWID = "ANACOM_RowId";

Property dummy As %String(TRUNCATE = 1);

}
