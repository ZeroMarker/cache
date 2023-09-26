Class web.PACArt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ART_Code";

Parameter SQLDESCRIPTION = "ART_Desc";

Parameter SQLROWID = "ART_RowId";

Property dummy As %String(TRUNCATE = 1);

}
