Include webimport

Class web.PACJaundice Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "JAUN_Code";

Parameter SQLDESCRIPTION = "JAUN_RowId";

Parameter SQLROWID = "JAUN_RowId";

}
