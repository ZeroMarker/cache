Class web.ORCIntubationSize Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ORINT_Code";

Parameter SQLDESCRIPTION = "ORINT_Desc";

Parameter SQLROWID = "ORINT_RowId";

Property dummy As %String(TRUNCATE = 1);

}
