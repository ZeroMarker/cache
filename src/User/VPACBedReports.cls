/// View for Nursing bed reports 
Class User.VPACBedReports [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 WARD_RowID, 
 WARD_Code,
 WARD_LocationDR,
 BED_Code,
 BED_SortingOrder,
 ADM_BookedStatus,
 PAADM_RowID,
 PAADM_AdmDate,
 PAADM_DischgDate,
 PAADM_EstimDischargeDate,
 PAADM_VisitStatus,
 PAADM_DepCode_DR->CTLOC_RowId,
 PAADM_DepCode_DR->CTLOC_Code,
 PAADM_DepCode_DR->CTLOC_Desc,
 PAADM_MainMRADM_DR->MRADM_PresentComplaint,
 PAADM_PAPMI_DR->PAPMI_No,
 PAADM_PAPMI_DR->PAPMI_DOB,
 PAADM_PAPMI_DR->PAPMI_Name, 
 PAADM_PAPMI_DR->PAPMI_Name2, 
 PAADM_PAPMI_DR->PAPMI_Name3,
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_AgeYr
 FROM
 SQLUser.PAC_Ward PAC_Ward,
 SQLUser.PAC_Bed PAC_Bed,
 SQLUser.PAC_BedAdm PAC_BedAdm,
 SQLUser.PA_Adm PA_Adm
 WHERE
 PAC_Ward.WARD_RowID = PAC_Bed.BED_WARD_ParRef AND
 PAC_Bed.BED_RowID =* PAC_BedAdm.ADM_ParRef AND
 PAC_BedAdm.ADM_PAADM_DR =* PA_Adm.PAADM_RowID
} ]
{

}
