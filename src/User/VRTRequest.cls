/// View Tracking Requests 
Class User.VRTRequest [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RTREQ_RowId,
 RTREQ_TransDate,
 RTREQ_TransTime,	
 RTREQ_Date,
 RTREQ_Time,
 RTREQ_Appt_DR->APPT_RowId,
 RTREQ_Appt_DR->APPT_AS_ParRef,	
 RTREQ_ReqReason_DR->REA_RowId,
 RTREQ_ReqReason_DR->REA_Desc,
 RTREQ_ReqUser_DR->SSUSR_RowId,
 RTREQ_ReqUser_DR->SSUSR_Initials,
 RTREQ_ReqUser_DR->SSUSR_Name,
 RTREQ_ReqLoc_DR->CTLOC_RowId,
 RTREQ_ReqLoc_DR->CTLOC_Code,
 RTREQ_ReqLoc_DR->CTLOC_Hospital_DR->HOSP_RowId,
 RTREQ_ReqLoc_DR->CTLOC_Hospital_DR->HOSP_Code,
 RTREQ_ReqLoc_DR->CTLOC_Hospital_DR->HOSP_Desc,
 RTREQ_ReqLoc_DR->CTLOC_Desc,
 RTREQ_Doctor_DR->CTPCP_Code,
 RTREQ_Doctor_DR->CTPCP_Desc,
 RTREQ_MRNo_DR->RTMAS_RowId,
 RTREQ_MRNo_DR->RTMAS_PatNo_DR->PAPMI_Name,
 RTREQ_MRNo_DR->RTMAS_PatNo_DR->PAPMI_Name2,
 RTREQ_MRNo_DR->RTMAS_PatNo_DR->PAPMI_No,
 RTREQ_MRNo_DR->RTMAS_PatNo_DR->PAPMI_DOB,
 RTREQ_Comments
 FROM
 RT_Request
} ]
{

}
