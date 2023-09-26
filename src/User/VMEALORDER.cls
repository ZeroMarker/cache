/// Meal Orders view
Class User.VMEALORDER [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 OEORI_ROWID,
 OEORI_OEORD_ParRef,
 OEORI_LabEpisodeNo,
 OEORI_DepProcNotes,
 OEORI_SttDat,
 OEORI_SttTim,
 OEORI_Remarks,
 OEORI_Qty,
 OEORI_SeqNo,
 OEORI_ItemGroup,
 OEORI_Protein,
 OEORI_Carbohydrate,
 OEORI_CoverMainIns,
 OEORI_PortEquipReq,
 OEORI_Fat,
 OEORI_DelayMeal,
 OEORI_PasterizeFood,
 OEORI_SterilizeUtelsis,
 OEORI_Doctor_DR->CTPCP_Code,
 OEORI_Doctor_DR->CTPCP_Desc,
 OEORI_Doctor_DR->CTPCP_PagerNo,
 ARCIM_Code,
 ARCIM_Desc,
 OEORI_ItemStat_DR->OSTAT_Code,
 OEORI_ItemStat_DR->OSTAT_Desc,
 ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Code,
 ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
 ARCIM_ItemCat_DR->ARCIC_Code,
 ARCIM_ItemCat_DR->ARCIC_Desc,
 OEORI_MealType_DR->MEALT_RowId,
 OEORI_MealType_DR->MEALT_Code,
 OEORI_MealType_DR->MEALT_Desc,
 OEORI_RiceType_DR->RIC_Code,
 OEORI_RiceType_DR->RIC_Desc,
 OEORI_Volume_DR->VOL_Code,
 OEORI_Volume_DR->VOL_Desc,
 OEORI_Energy_DR->ENE_Code,
 OEORI_Energy_DR->ENE_Desc,
 OEORI_Priority_DR->OECPR_Code,
 OEORI_Priority_DR->OECPR_Desc
 FROM	OE_OrdItem,ARC_ItmMast
 WHERE	OEORI_ItmMast_DR=ARCIM_RowId

} ]
{

}
