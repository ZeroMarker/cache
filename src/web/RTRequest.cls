Class web.RTRequest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1554;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RTREQ_RowId";

Parameter SQLDESCRIPTION = "RTREQ_RowId";

Parameter SQLROWID = "RTREQ_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindAllBookedReqClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllBookedReqFetch ]
{
}

ClassMethod FindAllBookedReqExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", RequestID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindAllBookedReqFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllBookedReqExecute ]
{
}

ClassMethod FindBookedReqClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBookedReqFetch ]
{
}

ClassMethod FindBookedReqExecute(ByRef QHandle As %Library.Binary, ID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindBookedReqFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindBookedReqExecute ]
{
}

ClassMethod FindMRRequestClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMRRequestFetch ]
{
}

ClassMethod FindMRRequestExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", ReasForRequest As %Library.String = "", CareProvider As %Library.String = "", RequestedFrom As %Library.String = "", LocDesc As %Library.String = "", PullingDateFrom As %Library.String = "", PullingDateTo As %Library.String = "", RequestDateFrom As %Library.String = "", RequestDateTo As %Library.String = "", RequiredDateFrom As %Library.String = "", RequiredDateTo As %Library.String = "", RequestID As %Library.String = "", Status1 As %Library.String = "", LogonLocID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindMRRequestFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMRRequestExecute ]
{
}

ClassMethod FindSearchPrefClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSearchPrefFetch ]
{
}

ClassMethod FindSearchPrefExecute(ByRef QHandle As %Library.Binary, Params As %Library.String, LstGrp As %Library.String) As %Library.Status
{
}

ClassMethod FindSearchPrefFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSearchPrefExecute ]
{
}

ClassMethod GetDefaultReqForPat(PatientID As %Library.String, UserID As %Library.String, HospID As %Library.String) As %Library.String
{
}

ClassMethod CheckHasPref(UserID As %Library.String) As %Library.String
{
}

ClassMethod CheckDSSummary(PatientID As %Library.String) As %Library.String
{
}

ClassMethod FindOustandingRequest(PatientID As %String = "", EpisodeID As %String = "") As %Boolean
{
}

ClassMethod GetPatientID(RequestID As %Library.String) As %Library.String
{
}

ClassMethod GetVerifyICD(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetPatientIDFromBatchID(BatchID As %Library.String) As %Library.String
{
}

ClassMethod GetRequestComment(RequestID As %Library.String) As %Library.String
{
}

ClassMethod GetSearchPref(PrefParams As %Library.String, LstGrp As %Library.String, QPref As %Library.String)
{
}

/// Get telephone extension from location codetables
ClassMethod GetTelExtFromLoc(LocID As %Library.String = "") As %Library.String
{
}

ClassMethod GetWorkingDay(date As %Library.String = "", days As %Library.String = "", loc As %Library.String = "") As %Library.String
{
}

ClassMethod IncompleteRegNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegistrationNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod MoveRequests(EpisodeID As %Library.String = "", locid As %Library.String = "")
{
}

ClassMethod DeleteTempHomeLoc(locid As %Library.String = "", RTMAVRowId As %Library.String = "")
{
}

ClassMethod MoveVolumes(EpisodeID As %Library.String, CurrWardID As %Library.String, logonuserid As %Library.String = "")
{
}

ClassMethod RetainValues()
{
}

ClassMethod URStripZero(Registration As %Library.String = "") As %Library.String
{
}

ClassMethod ValidateUR(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegistrationNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod ViewRequestsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ViewRequestsFetch ]
{
}

ClassMethod ViewRequestsExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", ReasForRequest As %Library.String = "", CareProvider As %Library.String = "", RequestedFrom As %Library.String = "", LocDesc As %Library.String = "", PullingDateFrom As %Library.String = "", PullingDateTo As %Library.String = "", RequestDateFrom As %Library.String = "", RequestDateTo As %Library.String = "", RequiredDateFrom As %Library.String = "", RequiredDateTo As %Library.String = "", RequestID As %Library.String = "", Status1 As %Library.String = "", LogonLocID As %Library.String = "", CurrLoc As %Library.String = "") As %Library.Status
{
}

ClassMethod ViewRequestsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ViewRequestsExecute ]
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
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

ClassMethod UpdateReqUserAndHosp(ReqId As %Library.String = "", UserID As %Library.String = "", logonhosp As %Library.String = "") As %Library.String
{
}

ClassMethod DefaultReqFor(ReqForLoc As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveBulk(PidMasVolid As %Library.String)
{
}

ClassMethod websysSavePreferences(compref As %Library.String)
{
}

Query FindAllBookedReq(PatientID As %Library.String, RequestID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTLOCDesc:%String,RTMAVDateCreated:%String,RTMAVTimeCreated:%String,RTREQTransDate:%String,RTREQTransTime:%String,SSUSRName,RTREQReqTelNo:%String,RTREQPagerNo:%String,READesc:%String,RTREQComments:%String,RTREQContactPerson:%String,RTREQRowId:%String,PatientID:%String,CurrLoc:%String,RTREVRowId:%String,RTReqLocDESC:%String,RTReqLocID:%String,voldesc:%String,mrtypetemp:%String,ReturnDate:%String")
{
}

Query FindBookedReq(ID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTLOCDesc:%String,RTMAVDateCreated:%String,RTMAVTimeCreated:%String,RTREQTransDate:%String,RTREQTransTime:%String,SSUSRName,RTREQReqTelNo:%String,RTREQPagerNo:%String,READesc:%String,RTREQComments:%String,RTREQContactPerson:%String,RTREQRowId:%String,PatientID:%String,reqrev:%String")
{
}

Query FindMRRequest(TSRTITM As %String, TSRTORD As %String, ReasForRequest As %String, CareProvider As %String, RequestedFrom As %String, LocDesc As %String, PullingDateFrom As %String, PullingDateTo As %String, RequestDateFrom As %String, RequestDateTo As %String, RequiredDateFrom As %String, RequiredDateTo As %String, RequestID As %String, Status1 As %String, LogonLocID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "rtmas:%String,patid:%String,Type:%String,UR:%String,Surname:%String,Given:%String,VolDesc:%String,TimeReq:%String,DateReq:%String,DateRequired:%String,CareProv:%String,ReqDep:%String,Ext:%String,Pager:%String,Comments:%String,Acknowledge:%String,ReqVolIds:%String,DelVolIds:%String,TimeRequired:%String,Booked:%String,RequestID:%String,CurrLoc:%String,MRType:%String,Received:%String,ContactPerson:%String,Status:%String,TypeCode:%String,HospCode:%String,PatientAttending:%String,pulldate:%String,batch:%String,dob:%String,volFlag:%String")
{
}

/// KK 23/Aug/2002 Log 26842 LookupQuery for RTRequest.RTREQ_BatchID
Query FindRTReqBatchID(RTREQBatchID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "BatchId,HIDDEN")
{
SELECT RTREQ_BatchID,RTREQ_RowId FROM SQLUser.RT_Request 
WHERE (%UPPER RTREQ_BatchID [ %UPPER :RTREQBatchID)
}

/// Sorted Priority date and Time ) List of all requests with Status B  for patient 
/// that was entered by UserID.
Query FindReqForPatByUser(PatientID As %Library.String, UserID As %Library.String, HospID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RequestID:%Library.String")
{
select DISTINCT RTREQ_RowId
from SQLUser.RT_Request,SQLUser.RT_ReqVol
where RTREQ_MRNo_DR->RTMAS_PatNo_DR=:PatientID
AND RTREQ_ReqUser_DR=:UserID
AND RTREV_RTREQ_ParRef=RTREQ_RowId
AND (RTREV_MasVol_DR->RTMAV_ActiveFlag NOT='N')
AND RTREV_Status='B'
AND ((RTREQ_MRNo_DR->RTMAS_MRType_DR->TYP_CTLOC_DR->CTLOC_Hospital_DR=:HospID)OR(:HospID IS NULL))
ORDER BY RTREQ_ReqReason_DR,RTREQ_Date,RTREQ_Time
}

Query FindSearchPref(Params, LstGrp) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc,HIDDEN")
{
}

Query ViewRequests(TSRTITM As %String, TSRTORD As %String, ReasForRequest As %String, CareProvider As %String, RequestedFrom As %String, LocDesc As %String, PullingDateFrom As %String, PullingDateTo As %String, RequestDateFrom As %String, RequestDateTo As %String, RequiredDateFrom As %String, RequiredDateTo As %String, RequestID As %String, Status1 As %String, LogonLocID As %String, CurrLoc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "rtmas:%String,patid:%String,Type:%String,UR:%String,Surname:%String,Given:%String,VolDesc:%String,TimeReq:%String,DateReq:%String,DateRequired:%String,CareProv:%String,ReqDep:%String,Ext:%String,Pager:%String,Comments:%String,Acknowledge:%String,ReqVolIds:%String,DelVolIds:%String,TimeRequired:%String,Booked:%String,RequestID:%String,CurrLoc:%String,MRType:%String,Received:%String,ContactPerson:%String,Status:%String,TypeCode:%String,HospCode:%String,PatientAttending:%String,pulldate:%String,batch:%String,dob:%String,volFlag:%String,ReasonColor:%Library.String,RTNo:%Library.String,CurrLocExt:%Library.String,MRReturnDate:%Library.String")
{
}

}
