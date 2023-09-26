/// View Req Vol for Exemption Report
Class User.VRTRequestVolume [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTREV_RTREQ_ParRef,
 RTMAV_RowId,
 RTMAV_RTMAS_ParRef,
 RTMAV_VolDesc,
 RTREV_Status, 
 RTMAV_CurrentLoc_DR->CTLOC_RowId,
 RTMAV_CurrentLoc_DR->CTLOC_Code, 
 RTMAV_CurrentLoc_DR->CTLOC_Desc
 FROM	RT_ReqVol, RT_MasVol
 WHERE	RTREV_MasVol_DR=RTMAV_RowId
} ]
{

}
