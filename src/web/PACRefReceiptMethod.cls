Include webimport

IncludeGenerator webimport

Class web.PACRefReceiptMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "REFMETH_Code";

Parameter SQLDESCRIPTION = "REFMETH_Desc";

Parameter SQLROWID = "REFMETH_RowId";

}
