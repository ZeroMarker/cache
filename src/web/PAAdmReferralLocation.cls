Include webimport

IncludeGenerator webimport

Class web.PAAdmReferralLocation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Parameter SQLCODE = "REFLOC_RowId";

Parameter SQLDESCRIPTION = "REFLOC_RowId";

Parameter SQLROWID = "REFLOC_RowId";

}
