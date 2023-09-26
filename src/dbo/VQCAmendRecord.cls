Class dbo.VQCAmendRecord [ ClassType = view, CompileAfter = (dbo.BTQCAmendLiquid, dbo.BTQCAmendMethod, dbo.BTQCMaterialLot, dbo.BTTestCode, dbo.QCAmendRecord, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_AmendRecord, ViewQuery = { SELECT     dbo.QC_AmendRecord.RowID, dbo.QC_AmendRecord.MaterialLotDR, dbo.QC_AmendRecord.TestCodeDR, dbo.QC_AmendRecord.LevelNo, 
 dbo.QC_AmendRecord.AmendDate, dbo.QC_AmendRecord.AmendTime, dbo.QC_AmendRecord.QCAmendMethodDR, dbo.QC_AmendRecord.QCAmendLiquidDR, 
 dbo.QC_AmendRecord.AmendUserDR, dbo.QC_AmendRecord.AddDate, dbo.QC_AmendRecord.AddTime, dbo.QC_AmendRecord.AddUserDR, 
 dbo.QC_AmendRecord.Remark, dbo.BTQC_MaterialLot.Code AS MaterialLotCode, dbo.BTQC_MaterialLot.LotNo AS MaterialLotLotNo, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName, dbo.BT_QCAmendMethod.Code AS QCAmendMethodCode, 
 dbo.BT_QCAmendMethod.CName AS QCAmendMethodName, dbo.BT_QCAmendLiquid.Code AS QCAmendLiquidCode, 
 dbo.BT_QCAmendLiquid.CName AS QCAmendLiquidName, AmendUser.Code AS AmendUserCode, AmendUser.CName AS AmendUserName, 
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName
 FROM         dbo.QC_AmendRecord LEFT OUTER JOIN
 dbo.BTQC_MaterialLot ON dbo.QC_AmendRecord.MaterialLotDR = dbo.BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.QC_AmendRecord.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.BT_QCAmendMethod ON dbo.QC_AmendRecord.QCAmendMethodDR = dbo.BT_QCAmendMethod.RowID LEFT OUTER JOIN
 dbo.BT_QCAmendLiquid ON dbo.QC_AmendRecord.QCAmendLiquidDR = dbo.BT_QCAmendLiquid.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AmendUser ON dbo.QC_AmendRecord.AmendUserDR = AmendUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.QC_AmendRecord.AddUserDR = AddUser.RowID} ]
{

}
