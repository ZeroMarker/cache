Class web.RTMasVol Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2228;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "RTMAV_DateToBeReturned";

ClassMethod GetDefaultMRTypeByLoginLoc(LoginLocId As %String = "") As %Library.String
{
}

ClassMethod GetMRHomeLoc(MRType As %Library.String = "") As %Library.String
{
}

ClassMethod GetMRHomeLocNew(MRType As %Library.String = "") As %Library.String
{
}

ClassMethod FindPatVolDescBroker(itmjs As %String = "", itmjsex As %String = "", PatientID As %String = "", VolDesc As %String = "", MasVolID As %String = "", type As %String = "", selvol As %String = "") As %Boolean
{
}

ClassMethod FindVolDescBroker(itmjs As %String = "", itmjsex As %String = "", PatientID As %String = "", VolDesc As %String = "", type As %String = "", MasVolID As %String = "", selvol As %String = "") As %Boolean
{
}

ClassMethod GetPatientIDTypeVol(PatientID As %String) As %Library.String
{
}

ClassMethod GetMainMRTypeByHospID(LogonLocId As %String) As %Library.String
{
}

ClassMethod GetMasVolDateTimeCreated(RTMasVolID As %String) As %Library.String
{
}

Query GetIDTypeVol(PatientID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Type:%String,Vol:%String")
{
 SELECT	RTMAV_RowId,RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc,RTMAV_VolDesc
 FROM	SQLUser.RT_MasVol
 WHERE	RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR=:PatientID
}

ClassMethod GetTempHomeLocation(RTMAVRowId As %String = "") As %String
{
}

ClassMethod FindLatestVolAssignedToEpis(EpisodeID As %String = "") As %String
{
}

/// Reterive the home location for a volume
ClassMethod GetMasVolHomeLoc(MasVolID As %String = "") As %String
{
}

ClassMethod GetMasVolHomeLocID(MasVolID As %String = "") As %String
{
}

Parameter SQLCODE = "RTMAV_RowId";

Parameter SQLDESCRIPTION = "RTMAV_VolDesc";

Parameter SQLROWID = "RTMAV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod ActivateVolume(compref As %Library.String)
{
}

ClassMethod CreateReceivedTrans()
{
}

ClassMethod FindActiveVolumesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindActiveVolumesFetch ]
{
}

ClassMethod FindActiveVolumesExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, VolumeNo As %Library.String) As %Library.Status
{
}

ClassMethod FindActiveVolumesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindActiveVolumesExecute ]
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", RequestID As %Library.String = "", VolDesc As %Library.String, DisplayBooked As %Library.String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod FindInactiveVolumesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindInactiveVolumesFetch ]
{
}

/// Log 57858, Bo: 19-07-2006: add flagAll to flag all the patients for the find.
ClassMethod FindInactiveVolumesExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", flagAll As %String = "N") As %Library.Status
{
}

ClassMethod FindInactiveVolumesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindInactiveVolumesExecute ]
{
}

ClassMethod FindMultiPatientReqClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMultiPatientReqFetch ]
{
}

ClassMethod FindMultiPatientReqExecute(ByRef QHandle As %Library.Binary, PatientIDs As %Library.String, RequestIDs As %Library.String, RequestList As %Library.String, VolDescs As %Library.String, ReqBatchID As %Library.String, MRNs As %Library.String, TYPIDs As %Library.String = "", RTMAVVolDesc As %Library.String = "", MODE As %Library.String = "") As %Library.Status
{
}

ClassMethod FindMultiPatientReqFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMultiPatientReqExecute ]
{
}

ClassMethod FindVolReqTransClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindVolReqTransFetch ]
{
}

ClassMethod FindVolReqTransExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", RequestID As %Library.String = "", VolDesc As %Library.String = "", DisplayBooked As %Library.String = "", BatchID As %Library.String = "", TYPID As %Library.String = "", MRN As %Library.String = "", reciprocal As %Library.String = "") As %Library.Status
{
}

ClassMethod FindVolReqTransFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindVolReqTransExecute ]
{
}

ClassMethod FindVolumeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindVolumeFetch ]
{
}

ClassMethod FindVolumeExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, RequestID As %Library.String) As %Library.Status
{
}

ClassMethod FindVolumeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindVolumeExecute ]
{
}

ClassMethod GenerateURN(PatientID As %String, TypeDesc As %String) As %String
{
}

ClassMethod GetAllActiveVolumeToRequest(RTMasterID As %String, all As %String, latest As %String, last2 As %String) As %String
{
}

ClassMethod GetAllReqInactVolTypes(PatientID As %String) As %String
{
}

ClassMethod GetDetails(ID As %Library.String)
{
}

ClassMethod GetHospitalDR(locid As %Library.String = "") As %Library.String
{
}

ClassMethod GetHospitalMR(HospID As %Library.String = "") As %Library.String
{
}

ClassMethod GetMicroFilmComment(RTMAVRowId As %Library.String = "") As %Library.String
{
}

ClassMethod GetMicroFilmDetail(RTMAVRowId As %Library.String = "") As %Library.String
{
}

ClassMethod GetNumberOfRequests(MasVolID As %Library.String) As %Library.Integer
{
}

ClassMethod GetParRef(PatientID As %Library.String) As %Library.String
{
}

/// SA 28.9.01: Called by RTVolume.Edit.CSP to set the existing Master MR Types and corresponding Volumes.
ClassMethod GetPatientTypeVol(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetVolDescs(RowIds As %Library.String) As %Library.String
{
}

ClassMethod GetVolDetails(RowIds As %Library.String) As %Library.String
{
}

ClassMethod GetVolumeNumber(EpisodeID As %Library.String) As %Library.String
{
	quit ""
}

ClassMethod InactiveVolume(PatientID As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerMRType(itmjs As %Library.String, itmjsex As %Library.String, PatientID As %Library.String, val As %Library.String) As %Library.Boolean
{
}

ClassMethod MergeAutoRequests(MergeVolumeToID As %Library.String = "")
{
}

ClassMethod NoOfVolInEpis(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod NumberofVolCheck(PatientID As %Library.String) As %Library.String
{
}

ClassMethod UpdateMicroFilm() As %Library.Boolean
{
}

ClassMethod UpdateTempHomeLoc() As %Library.Boolean
{
}

ClassMethod websysInsert(compref As %Library.String, id As %Library.String = "", ExistingIDTypeVol As %Library.String = "")
{
}

ClassMethod websysMoveVol(compref As %String)
{
}

ClassMethod websysSaveMove()
{
}

Method websysSaveTrans()
{
}

ClassMethod websysSaveVolRequest()
{
}

ClassMethod websysSaveVolTrans(MasVolID As %Library.String, ReqVolID As %Library.String, LocTo As %Library.String, Page As %Library.String = "", ReceivedBy As %Library.String = "", BatchID As %Library.String = "", Comments As %Library.String = "", userid As %Library.String = "", MRReturnDate As %Library.String = "", ReaForReq As %Library.String = "", return As %String = "", ByPassDepartmentalMR As %String = "")
{
}

ClassMethod websysSaveVolume()
{
}

//log49730 TedT

ClassMethod GetReqVolID(MasVolID As %String, stat As %String) As %String
{
}

/// log 57858: Bo 12-07-2006 - Create new method for Bulk Inactivate.
ClassMethod websysBulkInactivate(compref As %Library.String)
{
}

/// log 57858: Bo 20-07-2006 - Create new method for Reactivate volumes.
ClassMethod websysReactivateVolumes(compref As %Library.String)
{
}

Query Find(PatientID As %Library.String, RequestID As %String, VolDesc As %String, DisplayBooked) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,RTMASPatNoDR,RTMAVTYPDesc,RTMAVCurLocDesc,RTMAVVolDesc,RequestID,ReqVolID,RTREQReqTelNo,RTREQPagerNo,RTREQComments,RTREQDocDesc,RTREQLocDesc,Booked,RTMVTDate:%Date,RTMVTTime:%Time,Received:%String,ReceivedBy,ReceivedFrom,RTREQReqReasonDesc,RTREQSESSDesc,RTMAVCurLocCode,RTMVTComments,RTMAVRTMASParRef,RTMAVMRTypeVolDR,RTREQReqLocDR,PostDischStatus")
{
}

Query FindActiveVolumes(PatientID As %Library.String, VolumeNo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN:%String,MRType:%String,VolumeDesc:%String,HIDDEN:%String")
{
}

Query FindAllVolumes(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMAVRowId:%String,RTMAVCurrentLoc:%String")
{
SELECT RTMAV_RowId,RTMAV_CurrentLoc_DR
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID) 
AND (RTMAV_ActiveFlag = 'Y')
ORDER BY RTMAV_VolDesc DESC
}

/// Log 57858, Bo: 19-07-2006: add flagAll to flag all the patients for the find.
Query FindInactiveVolumes(PatientID As %String, flagAll As %String = "N") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,RTMAVRTMASParRef,TYPDesc,RTMAVVolDesc,RTMAVCurrentLocDesc,RTMAVMergedVolDesc,SSUSRName,RTMVTDate,RTMVTTime,TYPDesc1,MRNumber,RTMVTRowId,RTPatientID,RTPatientName,REACANCDesc,RTMAVDateCancelled,TransBatchID,UR")
{
}

Query FindMRType(PatientID As %Library.String, MRTypeDesc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "TYPDesc:%String,HIDDEN:%String")
{
SELECT DISTINCT BY(RTMAV_RTMAS_ParRef) RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc, RTMAV_RTMAS_ParRef->RTMAS_MRType_DR
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID) AND (RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc  %STARTSWITH:MRTypeDesc) AND (RTMAV_ActiveFlag ='Y')
ORDER BY RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc
}

Query FindMultiPatientReq(PatientIDs As %Library.String, RequestIDs As %Library.String, RequestList As %Library.String, VolDescs As %String, ReqBatchID As %String, MRNs As %String, TYPIDs As %String, RTMAVVolDesc As %String, MODE As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "RTMAVRowId,RTMASPatNoDR,RTMAVTYPDesc,RTMAVCurLocDesc,RTMAVVolDesc,RTMAVVolDescOnly,RequestID,ReqVolID,RTREQReqTelNo,RTREQPagerNo,RTREQComments,RTREQDocDesc,RTREQLocDesc,Booked,RTMVTDate:%Date,RTMVTTime:%Time,Received:%String,ReceivedBy:%String,ReceivedFrom:%String,PatName:%String,PatRegNo:%String,RTREQReqReasonDesc:%String,RTREQSESSDesc:%String,RTMAVCurLocCode,RTMAVRTMASParRef,RTREQReqLocDR,PostDischStatus,RecCnt,RTMVTComments,HomeLocDR,TempHomeLocDR,IsBatch,HomeLocList,ICDVerified,CurrMRN,MRReturnDate,HomeLocation")
{
}

Query FindPatVolDesc(PatientID As %Library.String, VolDesc As %String, MasVolID As %String, type As %String, selvol As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "TYPDesc:%String,RTMAVVolDesc:%String,HIDDEN:%String")
{
SELECT RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc, RTMAV_VolDesc, RTMAV_RowID
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID) AND (RTMAV_VolDesc  %STARTSWITH:VolDesc) AND (RTMAV_ActiveFlag ='Y')
AND  RTMAV_RowId NOT= :MasVolID
ORDER BY RTMAV_VolDesc DESC
}

Query FindPatientIDByMRN(MRN As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PatientID:%String")
{
SELECT distinct RTMAS_PatNo_DR 
FROM SQLUser.RT_Master
WHERE (RTMAS_MRNo =:MRN)
}

Query FindPatIDByMRNHospID(MRN As %String, HospID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PatientID:%String")
{
SELECT distinct RTMAS_PatNo_DR 
FROM SQLUser.RT_Master, SQLUser.RTC_MRecordType
WHERE (RTMAS_MRNo =:MRN)
AND RTMAS_MRType_DR=TYP_RowId
AND TYP_CTLOC_DR->CTLOC_Hospital_DR=:HospID
}

Query FindRequestVolume(PatientID As %Library.String, RequestID As %String, Location As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RTMAVRowId:%String,RTMASPatNoDR:%String,RTMAVMRTypeVolDR:%String,TYPDesc:%String,VolDesc:%String,CTLOCCode:%String,CTLOCDesc:%String,RTREQReqTelNo:%String,RTREQPagerNo:%String,RTREQComments:%String,CTPCPDesc:%String,RTMAVMRStatus:%String,RTMAVRequestDR:%String,RTMAVVolDesc:%String,RTMAVRTMASParRef:%String")
{
SELECT RTMAV_RowId, RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR, RTMAV_MRType_Vol_DR, RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc, RTMAV_MRType_Vol_DR->VOL_Desc, RTMAV_CurrentLoc_DR->CTLOC_Code, RTMAV_CurrentLoc_DR->CTLOC_Desc, RTMAV_Request_DR->RTREQ_ReqTelNo, RTMAV_Request_DR->RTREQ_PagerNo, RTMAV_Request_DR->RTREQ_Comments, RTMAV_Request_DR->RTREQ_Doctor_DR->CTPCP_Desc, RTMAV_MRStatus, RTMAV_Request_DR, RTMAV_VolDesc, RTMAV_RTMAS_ParRef
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR =:PatientID) 
AND ((RTMAV_Request_DR =:RequestID) OR (:RequestID IS NULL))
ORDER BY RTMAV_VolDesc DESC
}

Query FindVolDesc(PatientID As %Library.String, VolDesc As %String, type As %String, MasVolID As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "RTMAVVolDesc")
{
SELECT RTMAV_VolDesc
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID) AND (RTMAV_VolDesc  %STARTSWITH:VolDesc) AND (RTMAV_ActiveFlag ='Y') AND ((RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc =:type) OR (:type IS NULL))
AND  RTMAV_RowId NOT= :MasVolID
ORDER BY RTMAV_VolDesc DESC
}

Query FindVolReqTrans(PatientID As %Library.String, RequestID As %String, VolDesc As %String, DisplayBooked, BatchID As %String, TYPID As %String, MRN As %String, reciprocal As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,RTMASPatNoDR,RTMAVTYPDesc,RTMAVCurLocDesc,RTMAVVolDesc,RTMAVVolDescOnly,RequestID,ReqVolID,RTREQReqTelNo,RTREQPagerNo,RTREQComments,RTREQDocDesc,RTREQLocDesc,Booked,RTMVTDate:%Date,RTMVTTime:%Time,Received:%String,ReceivedBy,ReceivedFrom,RTREQReqReasonDesc,RTREQSESSDesc,RTMAVCurLocCode,RTMVTComments,RTMAVRTMASParRef,RTMAVMRTypeVolDR,RTREQReqLocDR,PostDischStatus,ReqStatus,HomeLocDR,TempHomeLocDR,CurLocTele,HomeLocList,CurrMRN,CurrLocID,MRReturnDate,HomeLoc,RTMAVDateCreated")
{
}

Query FindVolume(PatientID As %String, RequestID As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "RTMAVMRTypeVolDR,RTMAVRowId,RTMAVRTMASParRef,TYPDesc,RTMAVVolDesc,Booked,RTMAVCurLocDesc,RTMASPatNoDR,RTMAVCurLocCode,Received")
{
}

Query GetAllVolDesc(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMAVRowId:%String,RTMAVVolDesc:%String")
{
SELECT RTMAV_RowId,RTMAV_VolDesc
FROM SQLUser.RT_MasVol
WHERE (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID) 
AND (RTMAV_ActiveFlag = 'Y')
ORDER BY RTMAV_VolDesc DESC
}

Query GetAllVolInEpis(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMAVRowId:%String,RTMAVVolDesc:%String")
{
SELECT RTMAV_RowId,RTMAV_VolDesc
FROM SQLUser.RT_MasVol
WHERE (RTMAV_PAADM_DR = :EpisodeID) 
AND (RTMAV_ActiveFlag = 'Y')
ORDER BY RTMAV_VolDesc DESC
}

Query GetEpisodeID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,VolumeNumber:%String")
{
SELECT RTMAV_RowID, RTMAV_VolumeNumber
FROM SQLUser.RT_MasVol
WHERE RTMAV_PAADM_DR->PAADM_RowID =:EpisodeID
}

Query GetRequest(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMAVRowId:%String")
{
select distinct RTMAV_RowId from SQLUser.RT_MasVol, SQLUser.RT_Master, SQLUser.RT_Request
where (RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR = :PatientID)
AND (RTMAV_RTMAS_ParRef=RTREQ_MRNo_DR)
AND (RTREQ_Automatic='Y') 
AND (RTMAV_ActiveFlag = 'Y')
ORDER BY RTMAV_VolDesc DESC
}

Query GetTypeVol(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Type:%String,Vol:%String")
{
SELECT RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc,RTMAV_VolDesc
FROM SQLUser.RT_MasVol
WHERE RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR=:PatientID
}

Query GetTypeVolDesc(PatientID As %Library.String, MRDesc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Type:%String,Vol:%String")
{
SELECT RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc,RTMAV_VolDesc
FROM SQLUser.RT_MasVol
WHERE RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR=:PatientID
AND 	RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc=:MRDesc
ORDER BY RTMAV_VolDesc DESC
}

}
