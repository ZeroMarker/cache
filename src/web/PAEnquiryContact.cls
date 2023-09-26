Class web.PAEnquiryContact Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ENQ_RowId";

Parameter SQLDESCRIPTION = "ENQ_RowId";

Parameter SQLROWID = "ENQ_RowId";

/// ab 23.09.03 39225
/// hidden broker populates PAEnquiryContact.Edit with client details
ClassMethod FillClientDetails(itmjs As %String, itmjsex As %String, PatientID As %String = "") As %Boolean
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// ab 2.09.02
/// filters by doctor, resource, request status
/// ab 16.09.03 - 38218 added filters by single req status, enq id, request type, date from/to
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Doctor As %Library.String = "", Resource As %Library.String = "", ReqStatus As %Library.String = "", ENQRequestStatus As %String = "", ENQRowId As %String = "", ENQRequestType As %String = "", ENQDateFrom As %String = "", ENQDateTo As %String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query Find(Doctor As %Library.String, Resource As %Library.String, ReqStatus As %Library.String, ENQRequestStatus As %String, ENQRowId As %String, ENQRequestType As %String, ENQDateFrom As %String, ENQDateTo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ENQ_RowId,ENQ_CTCP_DR,ENQ_ContactName,ENQ_Date,PAPER_Name,ENQ_RequestStatus_DR,ENQ_RequestType_DR,ENQ_Resource_DR,ENQ_Time,ENQ_ContactNumber,CTPCP_Desc,RES_Desc")
{
}

}
