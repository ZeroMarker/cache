Class web.RTReqVol Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 745;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RTREV_RowId";

Parameter SQLDESCRIPTION = "RTREV_RowId";

Parameter SQLROWID = "RTREV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CancelRequest(compref As %Library.String = "", id As %Library.String = "")
{
}

ClassMethod CancelRequestByReqDate(DateReq As %Library.String = "", CancelReasonID As %Library.String = "", Comment As %Library.String = "") As %Library.String
{
}

ClassMethod FindReqClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReqFetch ]
{
}

ClassMethod FindReqExecute(ByRef QHandle As %Library.Binary, reqid As %Library.String) As %Library.Status
{
}

ClassMethod FindReqFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReqExecute ]
{
}

ClassMethod FindRequestVolumesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRequestVolumesFetch ]
{
}

ClassMethod FindRequestVolumesExecute(ByRef QHandle As %Library.Binary, MasVolIDs As %Library.String) As %Library.Status
{
}

ClassMethod FindRequestVolumesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRequestVolumesExecute ]
{
}

ClassMethod GetReqVolRowid(ParRef As %Library.String) As %Library.String
{
}

ClassMethod GetRequestVolIDs(DateReq As %Library.String = "") As %Library.String
{
}

ClassMethod GetRequestingLoc(PARREF As %Library.String) As %Library.String
{
}

ClassMethod GetWLDetails(WLRowid As %Library.String)
{
}

ClassMethod LookUpBrokerCancelReason(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod RTReqVolDelete(DeleteVolumes As %Library.String)
{
}

ClassMethod EditReturnDate(compref As %Library.String = "", id As %Library.String = "")
{
}

ClassMethod RTReqVolInsert(RTREVRTREQParRef As %Library.String, VolRowIDs As %Library.String, ReqRowids As %Library.String, LocToDesc As %Library.String, DeleteVol As %Library.String, CreateTransactions As %Library.String, Page As %Library.String, ReqTypeID As %Library.String = "", ReceivedBy As %Library.String = "", BatchID As %Library.String = "", RTREVRowId As %Library.String = "", UserID As %Library.String = "", HospID As %Library.String = "", MRReturnDate As %Library.String = "") As %Library.String
{
}

Query FindBookedRequest(VolID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTLOCDesc:%String,RTMAVDateCreated:%String,RTMAVTimeCreated:%String,RTREQTransDate:%String,RTREQTransTime:%String,SSUSRName,RTREQReqTelNo:%String,RTREQPagerNo:%String,READesc:%String,RTREQComments:%List")
{
SELECT RTREV_Doctor_DR->CTPCP_Desc,RTREV_RespLoc->CTLOC_Desc,RTREV_DateComputed, RTREV_TimeComputed,RTREV_RTREQ_ParRef->RTREQ_TransDate,RTREV_RTREQ_ParRef->RTREQ_TransTime,RTREV_RTREQ_ParRef->RTREQ_ReqUser_DR->SSUSR_Name, RTREV_RTREQ_ParRef->RTREQ_ReqTelNo, RTREV_RTREQ_ParRef->RTREQ_PagerNo, RTREV_RTREQ_ParRef->RTREQ_ReqReason_DR->REA_Desc, RTREV_RTREQ_ParRef->RTREQ_Comments
FROM SQLUser.RT_ReqVol
WHERE (RTREV_MasVol_DR = :VolID) AND (RTREV_Status = 'B')
}

Query FindReq(reqid As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "id,Volume,MasVolId")
{
}

Query FindRequest(Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTREVRowId,RTREVMasVolDR")
{
SELECT RTREV_RowId,RTREV_MasVol_DR FROM SQLUser.RT_ReqVol,SQLUser.RT_Request 
WHERE RTREV_RTREQ_ParRef=RTREQ_RowId
AND RTREQ_Date <= :Date
AND RTREV_Status ='B'
}

Query FindRequestVolumes(MasVolumeIDs As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "MasVolID,VolDesc,ReqVolID,Status,RegisNo,mrn")
{
}

Query LookUpCancelReason(desc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{


SELECT  REACANC_Desc,REACANC_RowId,REACANC_Code
FROM SQLUser.RTC_ReasonForCancel
WHERE ((%ALPHAUP REACANC_Desc  [%ALPHAUP :desc) OR (:desc IS NULL))
AND ((REACANC_DateFrom IS NULL) OR (Current_Date>=REACANC_DateFrom))
AND ((REACANC_DateTo IS NULL) OR (Current_Date<=REACANC_DateTo))
ORDER BY REACANC_Desc
}

}
