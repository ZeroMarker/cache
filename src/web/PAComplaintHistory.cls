Class web.PAComplaintHistory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 220;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetHistoryDisplayInfo(PARREF As %Library.String = "")
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

Parameter SQLCODE = "HIS_RowId";

Parameter SQLDESCRIPTION = "HIS_Details";

Parameter SQLROWID = "HIS_RowId";

Query ListHistory(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,Status:%Library.String,Detials:%Library.String,Time:%Library.Time,Date:%Library.Date")
{
SELECT HIS_RowId,HIS_Status_DR->CMS_Desc,HIS_Details,HIS_Time,HIS_Date
FROM SQLUSER.PA_ComplaintHistory
WHERE HIS_ParRef=:PARREF
}

}
