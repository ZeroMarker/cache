Class dbo.VBTQCMaterialLotRules [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLotRules, dbo.BTQCRules, dbo.VBTQCMaterialLot), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLotRules, ViewQuery = { SELECT     dbo.BTQC_MaterialLotRules.RowID, dbo.BTQC_MaterialLotRules.MaterialLotDR, dbo.BTQC_MaterialLotRules.QCRulesDR, dbo.BTQC_MaterialLotRules.Status, 
 dbo.V_BTQC_MaterialLot.Code AS MaterialLotCode, dbo.V_BTQC_MaterialLot.LotNo AS MaterialLotNo, dbo.V_BTQC_MaterialLot.MaterialCode, 
 dbo.V_BTQC_MaterialLot.MaterialName, dbo.BT_QCRules.Code AS QCRulesCode, dbo.BT_QCRules.CName AS QCRulesName
 FROM         dbo.BTQC_MaterialLotRules LEFT OUTER JOIN
 dbo.V_BTQC_MaterialLot ON dbo.BTQC_MaterialLotRules.MaterialLotDR = dbo.V_BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_QCRules ON dbo.BTQC_MaterialLotRules.QCRulesDR = dbo.BT_QCRules.RowID} ]
{

}
