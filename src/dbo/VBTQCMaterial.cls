Class dbo.VBTQCMaterial [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTQCMaterial, dbo.BTWorkGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_Material, ViewQuery = { SELECT     dbo.BTQC_Material.RowID, dbo.BTQC_Material.Code, dbo.BTQC_Material.CName, dbo.BTQC_Material.WorkGroupDR, dbo.BTQC_Material.MachineDR, 
 dbo.BTQC_Material.Levels, dbo.BTQC_Material.WaveLength, dbo.BTQC_Material.AutoSave, dbo.BTQC_Material.Remark, dbo.BTQC_Material.Sequence, 
 dbo.BTQC_Material.Active, dbo.BTMI_MachineParameter.Code AS MachineCode, dbo.BTMI_MachineParameter.CName AS MachineName, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.BTQC_Material LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTQC_Material.MachineDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BTQC_Material.WorkGroupDR = dbo.BT_WorkGroup.RowID} ]
{

}
