/// View ICD List 
Class User.VMRICDList [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 MRCID_Code,
 MRCID_Desc,
 MRCID_RowId,
 MRCID_BodyArea_DR->BODAR_Desc,
 MRCID_BodySysProbStat_DR->STAT_Desc
 FROM	MRC_ICDDx
} ]
{

}
