/// View Admission for IP Referral Form 
Class User.VPAAdmIPRef [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_CurrentBed_DR->BED_Code,
 PAADM_InpatBedReqTime,
 PAADM_InpatBedReqDate,
 PAADM_Priority_DR->CTACU_Code,
 PAADM_AdmDocCodeDR->CTPCP_Desc,
 PAADM_AdmDocCodeDR->CTPCP_PagerNo,
 PAADM_AdmDocCodeDR->CTPCP_Code,
 PAADM_CurrentWard_DR->WARD_Desc,
 PAADM_MainMRADM_DR,
 PAADM_MainMRADM_DR->MRADM_PresentComplaint
 FROM	PA_Adm
} ]
{

}
