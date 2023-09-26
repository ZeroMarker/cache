/// View Tracking Master 
Class User.VRTMaster [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTMAS_RowId,
 RTMAS_MRNo,
 RTMAS_PatNo_DR->PAPMI_ROWID,
 RTMAS_PatNo_DR->PAPMI_DOB,
 RTMAS_PatNo_DR->PAPMI_Name, 
 RTMAS_PatNo_DR->PAPMI_Name2, 
 RTMAS_PatNo_DR->PAPMI_No, 
 RTMAS_MRType_DR->TYP_Code,
 RTMAS_MRType_DR->TYP_Desc
 FROM	RT_Master
} ]
{

}
