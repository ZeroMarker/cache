/// View Patient Episode SOU details 
Class User.VPAAdmPatEpisodeSOU [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT           
 PAADM_ROWID,
 PAADM_ReportDate,       
 PAADM_DischgDate,
 PAADM_DischgTime,
 PAADM_InpatBedReqDate,
 PAADM_InpatBedReqTime,
 PAADM_TriageTime,
 PAADM_TriageDate,
 PAADM_MainMRADM_DR->MRADM_DischClassif_DR->DSCL_Code
 FROM    PA_Adm
} ]
{

}
