Class dbo.VBTMIMachineTestCode [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTMIMachineTestCode, dbo.BTTestCode), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineTestCode, ViewQuery = { SELECT     dbo.BTMI_MachineTestCode.RowID, dbo.BTMI_MachineTestCode.MachineParameterDR, dbo.BTMI_MachineTestCode.TestCodeDR, 
 dbo.BTMI_MachineTestCode.UPChannel, dbo.BTMI_MachineTestCode.ResultChannel, dbo.BTMI_MachineTestCode.Scale, dbo.BTMI_MachineTestCode.Active,dbo.BTMI_MachineTestCode.IsNotQC,dbo.BTMI_MachineTestCode.QCType, 
 dbo.BTMI_MachineParameter.Code AS MachineParameterCode, dbo.BTMI_MachineParameter.CName AS MachineParameterName, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.Synonym AS TestCodeSynonym,dbo.BT_TestCode.CName AS TestCodeName
 FROM         dbo.BTMI_MachineTestCode LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineTestCode.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BTMI_MachineTestCode.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
