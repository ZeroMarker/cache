/// Dicom Associate Image Check Order
Class User.VOEOrdItem [ ClassType = view, Not ProcedureBlock, SqlTableName = V_OE_OrdItem, ViewQuery = { SELECT OEORI_ItmMast_DR->ARCIM_Desc, OEORI_RowId FROM OE_OrdItem
} ]
{

}
