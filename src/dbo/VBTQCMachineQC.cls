Class dbo.VBTQCMachineQC [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTQCMachineQC, dbo.BTQCMaterial), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MachineQC, ViewQuery = { SELECT     dbo.BTQC_MachineQC.RowID, dbo.BTQC_MachineQC.MachineParameterDR, dbo.BTQC_MachineQC.MaterialDR, dbo.BTQC_MachineQC.LevelNo, 
 dbo.BTQC_MachineQC.SampleID,dbo.BTQC_MachineQC.SampleIDParallel,dbo.BTQC_MachineQC.TestCodeDRS, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, dbo.BTMI_MachineParameter.CName AS MachineParameterName, 
 dbo.BTQC_Material.Code AS MaterialCode, dbo.BTQC_Material.CName AS MaterialName,dbo.BTQC_MaterialLevel.CName AS LevelNoName,dbo.BTQC_MaterialLevel.Colour AS Colour
 FROM         dbo.BTQC_MachineQC LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTQC_MachineQC.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BTQC_Material ON dbo.BTQC_MachineQC.MaterialDR = dbo.BTQC_Material.RowID
 LEFT OUTER JOIN  dbo.BTQC_MaterialLevel ON (dbo.BTQC_MachineQC.MaterialDR = dbo.BTQC_MaterialLevel.MaterialDR and dbo.BTQC_MachineQC.LevelNo = dbo.BTQC_MaterialLevel.LevelNo)
 } ]
{

}
