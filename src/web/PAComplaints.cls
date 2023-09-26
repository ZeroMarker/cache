Class web.PAComplaints Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 523;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindIfLinksDataPAComplaints(RowID As %Library.String)
{
}

ClassMethod GetStatusDisplayInfo(PARREF As %Library.String = "")
{
}

ClassMethod ListComplaintsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListComplaintsFetch ]
{
}

ClassMethod ListComplaintsExecute(ByRef QHandle As %Library.Binary, Date As %Library.String = "", Status As %Library.String = "", Priority As %Library.String = "", Category As %Library.String = "", DateNextAction As %Library.String = "", Service As %Library.String = "", Clinician As %Library.String = "", PatientID As %Library.String = "", Keyword As %Library.String = "", Datefrom As %Library.String = "", Dateto As %Library.String = "", Type As %Library.String = "") As %Library.Status
{
}

ClassMethod ListComplaintsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListComplaintsExecute ]
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

Parameter SQLCODE = "PACM_RowId";

Parameter SQLDESCRIPTION = "PACM_RowId";

Parameter SQLROWID = "PACM_RowId";

Query ListComplaints(Date As %Date, Status As %String, Priority As %String, Category As %String, DateNextAction As %Date, Service As %String, Clinician As %String, RegistrationNo As %String, Keyword As %String, Datefrom As %Date, Dateto As %Date, Type As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowId:%Library.String,DateComplaint:%Library.Date,Status:%Library.String,Priority:%Library.String,Category:%Library.String,Client:%Library.String,DateNextAction:%Library.Date,Clinician:%Library.String,Service:%Library.String,Type:%Library.String")
{
}

}
