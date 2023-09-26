Include webimport

Class web.PACOriginalBooking Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ORIGBOOK_Code";

Parameter SQLDESCRIPTION = "ORIGBOOK_Desc";

Parameter SQLROWID = "ORIGBOOK_RowId";

}
