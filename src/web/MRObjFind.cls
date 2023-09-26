Include webimport

IncludeGenerator webimport

Class web.MRObjFind Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 139;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Parameter SQLCODE = "MROBJ_DocCode_DR";

Parameter SQLDESCRIPTION = "MROBJ_Desc";

Parameter SQLROWID = "MROBJ_RowId";

ClassMethod websysSaveNew(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysBeforeDelete(ByRef id As %String) As %Boolean
{
}

}
