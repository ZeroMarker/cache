/// Orders view 
Class User.VOEORIORDER [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 OEORI_ROWID,
 OEORI_OEORD_ParRef,
 OEORI_LabEpisodeNo,
 OEORI_DepProcNotes,
 OEORI_SttDat,
 OEORI_SttTim,
 OEORI_Remarks,
 OEORI_Doctor_DR->CTPCP_Code,
 OEORI_Doctor_DR->CTPCP_Desc,
 OEORI_Doctor_DR->CTPCP_PagerNo,
 OEORI_ItmMast_DR->ARCIM_Code,
 OEORI_ItmMast_DR->ARCIM_Desc,
 OEORI_ItemStat_DR->OSTAT_Code,
 OEORI_ItemStat_DR->OSTAT_Desc,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Code,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_Code,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_Desc
 FROM	OE_OrdItem

} ]
{

}
