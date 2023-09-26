Include webimport

Class web.PACDiabetes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DIAB_Code";

Parameter SQLDESCRIPTION = "DIAB_Desc";

Parameter SQLROWID = "DIAB_RowId";

}
