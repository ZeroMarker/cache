/// View Master Volume
Class User.VRTMasterVolume [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTMAV_RowId,
 RTMAV_RTMAS_ParRef,
 RTMAV_VolDesc,
 RTMAV_DateCreated,
 RTMAV_TimeCreated, 
 RTMAV_CreatedbyUser_Dr->SSUSR_RowId, 
 RTMAV_CreatedbyUser_Dr->SSUSR_Initials, 
 RTMAV_CreatedbyUser_Dr->SSUSR_Name,
 RTMAV_CurrentLoc_DR->CTLOC_RowId,
 RTMAV_CurrentLoc_DR->CTLOC_Code, 
 RTMAV_CurrentLoc_DR->CTLOC_Desc,
 RTMAV_CurrentLoc_DR->CTLOC_Type,
 RTMAV_CurrentLoc_DR->CTLOC_Hospital_DR->Hosp_RowId,
 RTMAV_CurrentLoc_DR->CTLOC_Hospital_DR->Hosp_Code,
 RTMAV_CurrentLoc_DR->CTLOC_Hospital_DR->Hosp_Desc, 
 RTMAV_Request_DR
 FROM	RT_MasVol
} ]
{

}
