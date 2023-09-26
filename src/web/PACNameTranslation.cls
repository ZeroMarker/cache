Include webimport

IncludeGenerator webimport

Class web.PACNameTranslation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "NAME_Name2";

Parameter SQLDESCRIPTION = "NAME_Name1";

Parameter SQLROWID = "NAME_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod websysAddNew(val As %String = "") As %String
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod websysSaveNew(compref As %String, id As %String)
{
}

}
