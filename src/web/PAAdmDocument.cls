Class web.PAAdmDocument Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DOC_RowId";

Parameter SQLDESCRIPTION = "DOC_File";

Parameter SQLROWID = "DOC_RowId";

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

}
