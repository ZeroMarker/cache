/// View Volume Transfer
Class User.VRTVolumeTrans [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTMVT_RowId,
 RTMVT_RTMAV_ParRef,
 RTMVT_Date,
 RTMVT_Time,
 RTMVT_Type, 
 RTMVT_UserIDTo_Dr->SSUsr_Initials, 
 RTMVT_UserIDTo_Dr->SSUsr_Name,
 RTMVT_LocFrom_DR->CTLOC_Code, 
 RTMVT_LocFrom_DR->CTLOC_Desc,
 RTMVT_LocTo_DR, 
 RTMVT_ReqVol_DR
 FROM	RT_MVTrans
} ]
{

}
