Class dbo.VBTCollectPrompt [ ClassType = view, CompileAfter = (dbo.BTCollectPrompt, dbo.BTHospital), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_CollectPrompt, ViewQuery = { SELECT     dbo.BT_CollectPrompt.RowID, dbo.BT_CollectPrompt.Code, dbo.BT_CollectPrompt.CName, dbo.BT_CollectPrompt.HospitalDR, dbo.BT_CollectPrompt.Sequence, 
 dbo.BT_CollectPrompt.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_CollectPrompt LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_CollectPrompt.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
