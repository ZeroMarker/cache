/// View Tracking Transactions 
Class User.VRTMVTrans [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTMVT_Date,
 RTMVT_Time,
 RTMVT_ReqVol_DR->RTREV_Status,
 RTMVT_ReqVol_DR->RTREV_Doctor_DR->CTPCP_Desc,
 RTMVT_ReqVol_DR->RTREV_MasVol_DR->RTMAV_HomeLoc_DR->CTLOC_Hospital_DR->HOSP_Desc,
 RTMVT_ReqVol_DR->RTREV_MasVol_DR->RTMAV_VolDesc,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name2,
 RTMVT_ReqVol_DR->RTREV_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_No,
 RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_ReqReason_DR->REA_Desc,
 RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_BatchId,
 RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_TransDate,
 RTMVT_ReqVol_DR->RTREV_RTREQ_ParRef->RTREQ_TransTime,
 RTMVT_UserIdFrom_DR->SSUSR_Name
 FROM
 RT_MVTrans
} ]
{

}
