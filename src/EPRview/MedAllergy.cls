Class EPRview.MedAllergy [ ClassType = view, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = MedAllergy, ViewQuery = { select  MI.MRCID_ICD9CM_Code ,MI.MRCID_Desc ,MIA.ALIAS_Text from  SQLUser.MRC_ICDAlias MIA ,SQLUser.MRC_ICDDx MI where MIA.ALIAS_ParRef = MI.MRCID_RowId and (MI.MRCID_ICD9CM_Code like 'T88%' or MI.MRCID_Desc ='无' or MI.MRCID_Desc ='暂未发现' )and ( MI.MRCID_DateActiveTo is null  ) group by MI.MRCID_ICD9CM_Code } ]
{

}
