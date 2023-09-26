Class web.ORCIntubGrade Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INGRA_Code";

Parameter SQLDESCRIPTION = "INGRA_Desc";

Parameter SQLROWID = "INGRA_RowId";

Property dummy As %String(TRUNCATE = 1);

}
