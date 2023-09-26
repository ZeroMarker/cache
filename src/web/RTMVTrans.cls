Class web.RTMVTrans Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 474;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RTMVT_RowId";

Parameter SQLDESCRIPTION = "RTMVT_RowId";

Parameter SQLROWID = "RTMVT_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, ReqVolIds As %Library.String) As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod GetTransType(parref As %Library.String) As %Library.String
{
}

ClassMethod UpdateVolLoc(TransID As %Library.String = "")
{
}

ClassMethod mergeRequests(MergeVolumeFromID As %Library.String, MergeVolumeToID As %Library.String, DeleteRequest As %Library.String = "")
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

ClassMethod websysInsert(MasVolID As %Library.String, ReqVolID As %Library.String, LocTo As %Library.String)
{
}

ClassMethod websysInsertReceived()
{
}

ClassMethod websysInsertReceivedAll()
{
}

ClassMethod websysMergeVolume(compref As %Library.String)
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

Query Find(ReqVolIds As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RTMVTRowId,RTMVTType,RTMVTLocFromDesc,RTMVTLocToDesc,RTMVTDate,RTMVTTime,RTMVTUserTo,RTMVTUserFrom,RTMVTVolDesc,TYPDesc,RTMVTRTREQComments,RTMVTRTMAVParRef,RTMASPatNoDR,RTMVTLocToCode,RTMVTTelNo,RTREVRTREQParRef,RTMVTBatchID,RTMVTComments,RTMVTContactPerson,RTMVTReqTelNo,RTMVTExtension,RTMVTDoctor,MRReturnDate,RTMVTReasonMOVEDesc")
{
}

Query FindTrans(reqvolid As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMVTRowId,RTMVTType,RTMVTLocFromDesc,RTMVTLocToDesc,RTMVTDate,RTMVTTime,RTMVTUserTo,RTMVTReasonMOVEDesc,RTMVTUserFrom,RTMVTVolDesc,TYPDesc,RTMVTRTREQComments,RTMVTRTMAVParRef,RTMASPatNoDR,MergedVolDesc,RTMVTLocToCode,RTMVTTelNo,RTREVRTREQParRef,RTMVTBatchID,RTMVTRTMAVMergeDR,MergeTypeFrom,RTMVTComments,RTMVTContactPerson,RTMVTReqTelNo,RTMVTExtension,RTMVTDoctor")
{
SELECT RTMVT_RowId, RTMVT_Type,  RTMVT_LocFrom_DR->CTLOC_Desc, RTMVT_LocTo_DR->CTLOC_Desc, RTMVT_Date, RTMVT_Time, RTMVT_UserIdTo_DR->SSUSR_Name, RTMVT_ReasonForMove_DR->MOVE_Desc, RTMVT_UserIdFrom_DR->SSUSR_Name,RTMVT_RTMAV_ParRef->RTMAV_VolDesc,RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc,RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_Comments,RTMVT_RTMAV_ParRef,RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR, RTMVT_RTMAVMerge_DR->RTMAV_VolDesc, RTMVT_LocTo_DR->CTLOC_Code, RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_ReqTelNo, RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef, RTMVT_BatchID, RTMVT_RTMAVMerge_DR->RTMAV_VolDesc, RTMVT_RTMAVMerge_DR->RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc, RTMVT_Comments, RTMVT_ContactPerson,RTMVT_ReqTelNo,RTMVT_Extension,RTMVT_Doctor_DR->CTPCP_Desc
FROM SQLUser.RT_MVTrans
WHERE RTMVT_RTMAV_ParRef->RTMAV_RowId =:reqvolid
ORDER BY RTMVT_Date Desc, RTMVT_Time Desc
}

Query FindTransByBatch(BatchID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RTMVTRowId,RTMVTType,RTMVTLocFromDesc,RTMVTLocToDesc,RTMVTDate,RTMVTTime,RTMVTUserTo,RTMVTReasonMOVEDesc,RTMVTUserFrom,RTMVTVolDesc,TYPDesc,RTMVTRTREQComments,RTMVTRTMAVParRef,RTMASPatNoDR,MergedVolDesc,RTMVTLocToCode,RTMVTTelNo,RTREVRTREQParRef,RTMVTBatchID,RTMVTRTMAVMergeDR,MergeTypeFrom,PAPMINo,RTMASMRNo")
{
SELECT RTMVT_RowId, RTMVT_Type,  RTMVT_LocFrom_DR->CTLOC_Desc, RTMVT_LocTo_DR->CTLOC_Desc, RTMVT_Date, RTMVT_Time, RTMVT_UserIdTo_DR->SSUSR_Name, RTMVT_ReasonForMove_DR->MOVE_Desc, RTMVT_UserIdFrom_DR->SSUSR_Name,RTMVT_RTMAV_ParRef->RTMAV_VolDesc,RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc,RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_Comments,RTMVT_RTMAV_ParRef,RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR, RTMVT_RTMAVMerge_DR->RTMAV_VolDesc, RTMVT_LocTo_DR->CTLOC_Code, RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_ReqTelNo, RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef, RTMVT_BatchID, RTMVT_RTMAVMerge_DR->RTMAV_VolDesc, RTMVT_RTMAVMerge_DR->RTMAV_RTMAS_ParRef->RTMAS_MRType_DR->TYP_Desc, RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_PatNo_DR->PAPMI_No, RTMVT_RTMAV_ParRef->RTMAV_RTMAS_ParRef->RTMAS_MRNo
FROM SQLUser.RT_MVTrans
WHERE  RTMVT_BatchID =:BatchID
}

}
