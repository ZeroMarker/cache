Class web.ARCServTax Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ARCST_Code";

Parameter SQLDESCRIPTION = "ARCST_Desc";

Parameter SQLROWID = "ARCST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
