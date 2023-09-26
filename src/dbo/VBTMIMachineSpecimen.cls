Class dbo.VBTMIMachineSpecimen [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTMIMachineSpecimen, dbo.BTSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineSpecimen, ViewQuery = { SELECT     dbo.BTMI_MachineSpecimen.RowID, dbo.BTMI_MachineSpecimen.MachineParameterDR, dbo.BTMI_MachineSpecimen.SpecimenDR, 
 dbo.BTMI_MachineSpecimen.Channel, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName AS SpecimenIName, 
 dbo.BT_Specimen.XName AS SpecimenXName
 FROM         dbo.BTMI_MachineSpecimen LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineSpecimen.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BTMI_MachineSpecimen.SpecimenDR = dbo.BT_Specimen.RowID} ]
{

}
