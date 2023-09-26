Include webimport

Class web.PACManagementOfAbortion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MABORT_Code";

Parameter SQLDESCRIPTION = "MABORT_Desc";

Parameter SQLROWID = "MABORT_RowId";

}
