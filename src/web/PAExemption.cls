Class web.PAExemption Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 125;

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod CheckBeforeDelete(ID As %Library.String)
{
}

Parameter SQLCODE = "EX_RowId";

Parameter SQLDATEFROM = "EX_DateFrom";

Parameter SQLDATETO = "EX_DateTo";

Parameter SQLDESCRIPTION = "EX_RowId";

Parameter SQLROWID = "EX_RowId";

}
