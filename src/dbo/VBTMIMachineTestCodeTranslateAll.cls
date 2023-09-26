Class dbo.VBTMIMachineTestCodeTranslateAll [ ClassType = view, CompileAfter = (dbo.BTMIMachineTestCode, dbo.BTMIMachineTestCodeTrans), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineTestCodeTranslateAll, ViewQuery = { SELECT     dbo.BTMI_MachineTestCodeTrans.RowID, dbo.BTMI_MachineTestCodeTrans.MachineTestCodeDR, dbo.BTMI_MachineTestCodeTrans.Result, 
 dbo.BTMI_MachineTestCodeTrans.NewResult, dbo.BTMI_MachineTestCode.RowID AS MachineTestCodeRowID, dbo.BTMI_MachineTestCode.MachineParameterDR, 
 dbo.BTMI_MachineTestCode.TestCodeDR, dbo.BTMI_MachineTestCode.UPChannel, dbo.BTMI_MachineTestCode.ResultChannel, dbo.BTMI_MachineTestCode.Scale, 
 dbo.BTMI_MachineTestCode.Active
 FROM         dbo.BTMI_MachineTestCodeTrans LEFT OUTER JOIN
 dbo.BTMI_MachineTestCode ON dbo.BTMI_MachineTestCodeTrans.MachineTestCodeDR = dbo.BTMI_MachineTestCode.RowID} ]
{

}
