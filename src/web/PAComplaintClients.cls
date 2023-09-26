Class web.PAComplaintClients Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

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

Parameter SQLCODE = "PAT_RowId";

Parameter SQLDESCRIPTION = "PAT_RowId";

Parameter SQLROWID = "PAT_RowId";

Query ListClients(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,Forename:%Library.String,Surname:%Library.String,Dob:%Library.Date,PatientID:%Library.String,TelephoneNo:%Library.String")
{
SELECT PAT_RowId,PAT_Person_DR->PAPER_Name,
PAT_Person_DR->PAPER_Name2,PAT_Person_DR->PAPER_Dob,
PAT_Person_DR->PAPER_RowId,PAT_Person_DR->PAPER_TelH
FROM SQLUSER.PA_ComplaintClients
WHERE PAT_ParRef=:PARREF
}

}
