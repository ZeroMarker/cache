Include webimport

Class web.PACAntenatalSteroid Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANTST_Code";

Parameter SQLDESCRIPTION = "ANTST_Desc";

Parameter SQLROWID = "ANTST_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

}
