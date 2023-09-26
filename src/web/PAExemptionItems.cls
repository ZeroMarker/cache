Class web.PAExemptionItems Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Parameter SQLCODE = "ITM_RowId";

Parameter SQLDESCRIPTION = "ITM_RowId";

Parameter SQLROWID = "ITM_RowId";

}
