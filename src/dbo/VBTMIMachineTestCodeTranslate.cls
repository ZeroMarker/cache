Class dbo.VBTMIMachineTestCodeTranslate [ ClassType = view, CompileAfter = (dbo.BTMIMachineTestCodeTrans, dbo.VBTMIMachineTestCode), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineTestCodeTranslate, ViewQuery = { SELECT     dbo.BTMI_MachineTestCodeTrans.RowID, dbo.BTMI_MachineTestCodeTrans.MachineTestCodeDR, dbo.BTMI_MachineTestCodeTrans.Result, 
 dbo.BTMI_MachineTestCodeTrans.NewResult, dbo.V_BTMI_MachineTestCode.MachineParameterCode, dbo.V_BTMI_MachineTestCode.MachineParameterName, 
 dbo.V_BTMI_MachineTestCode.TestCodeCode, dbo.V_BTMI_MachineTestCode.TestCodeName
 FROM         dbo.BTMI_MachineTestCodeTrans LEFT OUTER JOIN
 dbo.V_BTMI_MachineTestCode ON dbo.BTMI_MachineTestCodeTrans.MachineTestCodeDR = dbo.V_BTMI_MachineTestCode.RowID} ]
{

}
