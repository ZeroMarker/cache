/// View Tracking
Class User.VRTTracking [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTMVT_Date,
 RTMVT_Time,
 RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef,
 RTMVT_ReqVol_DR->RTREV_Status,
 RTMVT_ReqVol_DR->RTREV_MasVol_DR->RTMAV_VolDesc,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name2,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_No,
 RTMVT_UserIdFrom_DR->SSUSR_Name
 FROM
 RT_MVTrans
} ]
{

}
