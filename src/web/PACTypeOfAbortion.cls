Include webimport

Class web.PACTypeOfAbortion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 65;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TABORT_Code";

Parameter SQLDESCRIPTION = "TABORT_Desc";

Parameter SQLROWID = "TABORT_RowId";

}
