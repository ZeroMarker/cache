Class web.PACPuerperium Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PUER_Code";

Parameter SQLDESCRIPTION = "PUER_Desc";

Parameter SQLROWID = "PUER_RowId";

}
