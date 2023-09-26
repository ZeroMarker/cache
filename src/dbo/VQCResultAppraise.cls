Class dbo.VQCResultAppraise [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLot, dbo.BTTestCode, dbo.QCResultAppraise, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_ResultAppraise, ViewQuery = { SELECT     dbo.QC_ResultAppraise.RowID, dbo.QC_ResultAppraise.MaterialLotDR, dbo.QC_ResultAppraise.TestCodeDR, dbo.QC_ResultAppraise.LevelNo, 
 dbo.QC_ResultAppraise.AppraiseDate, dbo.QC_ResultAppraise.AppraiseTime, dbo.QC_ResultAppraise.AppraiseUserDR, dbo.QC_ResultAppraise.Remark, 
 dbo.QC_ResultAppraise.AddDate, dbo.QC_ResultAppraise.AddTime, dbo.QC_ResultAppraise.AddUserDR, dbo.QC_ResultAppraise.Reported, 
 dbo.BTQC_MaterialLot.Code AS MaterialLotCode, dbo.BTQC_MaterialLot.LotNo AS MaterialLotLotNo, dbo.BT_TestCode.Code AS TestCodeCode, 
 dbo.BT_TestCode.CName AS TestCodeName, AppraiseUser.Code AS AppraiseUserCode, AppraiseUser.CName AS AppraiseUserName, 
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName
 FROM         dbo.QC_ResultAppraise LEFT OUTER JOIN
 dbo.BTQC_MaterialLot ON dbo.QC_ResultAppraise.MaterialLotDR = dbo.BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.QC_ResultAppraise.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AppraiseUser ON dbo.QC_ResultAppraise.AppraiseUserDR = AppraiseUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.QC_ResultAppraise.AddUserDR = AddUser.RowID} ]
{

}
