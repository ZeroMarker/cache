Include webimport

Class web.PACPhototherapy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PHOTO_Code";

Parameter SQLDESCRIPTION = "PHOTO_RowId";

Parameter SQLROWID = "PHOTO_RowId";

}
