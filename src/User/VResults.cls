/// View Results report 
Class User.VResults [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 TR_RowId, TR_DateVerified, TR_TimeVerified,
 TR_ResStat_DR->RESST_Code,
 SEC_Text,
 TR_Action_DR->ACT_Code,
 OEORI_RowId, OEORI_LabReceiveDate, OEORI_LabReceiveTime,
 OEORI_Doctor_DR->CTPCP_Desc,
 ARCIM_Desc,
 PAADM_PAPMI_DR->PAPMI_No, 
 PAADM_PAPMI_DR->PAPMI_Name, 
 PAADM_PAPMI_DR->PAPMI_Name2,
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_Dob, 
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_AgeYr, 
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_TelH,
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_CityCode_DR->CTCIT_Desc,
 PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_SEX_DR->CTSEX_Code,
 ORCAT_Code,
 PAADM_AdmNo
 FROM
 OE_TextResult,
 OE_Order,
 OE_TextResultSection,
 PA_Adm,
 OE_OrdItem,
 ARC_ItmMast,
 ARC_ItemCat,
 OEC_OrderCategory
 WHERE
 OE_TextResult.TR_OEORD_DR = OE_Order.OEORD_RowId AND
 OE_TextResult.TR_RowId = OE_TextResultSection.SEC_ParRef AND
 OE_Order.OEORD_Adm_DR = PA_Adm.PAADM_RowID AND
 OE_Order.OEORD_RowId = OE_OrdItem.OEORI_OEORD_ParRef AND
 OE_OrdItem.OEORI_ItmMast_DR = ARC_ItmMast.ARCIM_RowId AND
 ARC_ItmMast.ARCIM_ItemCat_DR = ARC_ItemCat.ARCIC_RowId AND
 ARC_ItemCat.ARCIC_OrdCat_DR = OEC_OrderCategory.ORCAT_RowId
} ]
{

}
