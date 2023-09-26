Class EMRview.EMRXMILFILELIST [ ClassType = view, CompileAfter = (EMRinstance.ECRecord, EMRinstance.Export.Succeed, EMRinstance.InstanceData, EMRmeta.EMRTemplateCategory), DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = EMRXMILFILELIST, ViewQuery = { SELECT DISTINCT 
 		EMRinstance_Export.Succeed.PatientID,
 		EMRinstance_Export.Succeed.EpisodeID,
 		EMRInstance.ECRecord.ID As ECRecordID,
 		EMRInstance.InstanceData.childsub ,
 		EMRmeta.EMRTemplateCategory.CategoryName
 		FROM EMRinstance_Export.Succeed  
 		INNER JOIN EMRInstance.InstanceData ON EMRinstance_Export.Succeed.InstanceID = EMRInstance.InstanceData.ID
 		INNER JOIN EMRInstance.ECRecord ON EMRInstance.InstanceData.TheECRecord = EMRInstance.ECRecord.ID
 		INNER JOIN EMRmeta.EMRTemplateCategory ON  EMRInstance.ECRecord.ChartItemID->ID = EMRmeta.EMRTemplateCategory.ID
 	WHERE Type='XML'} ]
{

}
