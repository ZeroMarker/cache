Class dbo.VBTQCMaterialLevel [ ClassType = view, CompileAfter = (dbo.BTQCMaterial, dbo.BTQCMaterialLevel), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLevel, ViewQuery = { SELECT     dbo.BTQC_MaterialLevel.RowID, dbo.BTQC_MaterialLevel.MaterialDR, dbo.BTQC_MaterialLevel.LevelNo, dbo.BTQC_MaterialLevel.CName, 
 dbo.BTQC_Material.Code AS MaterialCode, dbo.BTQC_Material.CName AS MaterialName
 FROM         dbo.BTQC_MaterialLevel LEFT OUTER JOIN
 dbo.BTQC_Material ON dbo.BTQC_MaterialLevel.MaterialDR = dbo.BTQC_Material.RowID} ]
{

}
