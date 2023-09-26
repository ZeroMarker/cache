Include webimport

Class web.PATrafficAccidentContact Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Parameter SQLCODE = "CONT_RowId";

Parameter SQLDATEFROM = "CONT_DateFrom";

Parameter SQLDESCRIPTION = "CONT_RowId";

Parameter SQLDATETO = "CONT_DateTo";

Parameter SQLROWID = "CONT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod endDateLastContact(TRFID As %Library.String = "", id As %String = "")
{
}

ClassMethod saveDelete(id As %String)
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

}
