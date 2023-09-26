Class dbo.VBTQCResultToNumber [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTQCResultToNumber, dbo.BTTestCode), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_ResultToNumber, ViewQuery = { SELECT     dbo.BTQC_ResultToNumber.RowID, dbo.BTQC_ResultToNumber.MachineParameterDR, dbo.BTQC_ResultToNumber.TestCodeDR, 
 dbo.BTQC_ResultToNumber.OldResult, dbo.BTQC_ResultToNumber.NewResult, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName
 FROM         dbo.BTQC_ResultToNumber LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTQC_ResultToNumber.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BTQC_ResultToNumber.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
