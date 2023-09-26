/// View Diagnosis 
Class User.VMRDiagnos [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 MRDIA_MRADM_ParRef,
 MRDIA_MRADM_ParRef->MRADM_ADM_DR,
 MRDIA_ICDCode_DR->MRCID_Code,
 MRDIA_ICDCode_DR->MRCID_Desc,
 MRDIA_SignSym_DR->DSYM_Desc,
 MRDIA_ICDCode_DR->MRCID_BodyArea_DR->BODAR_Desc
 FROM	MR_Diagnos
} ]
{

}
