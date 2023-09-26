Include webimport

Class web.PACBookingChangePlace Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "BCP_Code";

Parameter SQLDESCRIPTION = "BCP_Desc";

Parameter SQLROWID = "BCP_RowId";

}
