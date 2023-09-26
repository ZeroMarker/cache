Class web.PAClientDiaryDayData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 25;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CLD_RowId";

Parameter SQLDESCRIPTION = "CLD_RowId";

Parameter SQLROWID = "CLD_RowId";

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
