Include webimport

Class web.PACApgarScore Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "APGS_Code";

Parameter SQLDESCRIPTION = "APGS_Desc";

Parameter SQLROWID = "APGS_RowId";

}
