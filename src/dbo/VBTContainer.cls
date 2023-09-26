Class dbo.VBTContainer [ ClassType = view, CompileAfter = (dbo.BTContainer, dbo.BTHospital), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Container, ViewQuery = { 
 SELECT     dbo.BT_Container.RowID, dbo.BT_Container.Code, dbo.BT_Container.CName, dbo.BT_Container.HospitalDR, dbo.BT_Container.Volumn, dbo.BT_Container.Color, 
 dbo.BT_Container.Remark, dbo.BT_Container.Sequence, dbo.BT_Container.Active,dbo.BT_Container.Photo, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_Container LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Container.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
