Include webimport

Class web.PACFeedOnDischarge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "FEEDOD_Code";

Parameter SQLDESCRIPTION = "FEEDOD_Desc";

Parameter SQLROWID = "FEEDOD_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

}
