/// View Insurance Episode 
Class User.VPAInsurance [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 INS_ParRef,
 INS_RowId,
 INS_InsType_DR,
 INS_CardNo,
 INS_ConcessionCardNo,
 INS_ConcessionCardExpDate,
 INS_SafetyNetCardNo,
 INS_SafetyNetCardExpDate,
 INS_AuxInsType_DR->AUXIT_Code,
 INS_AuxInsType_DR->AUXIT_Desc,
 INS_InsType_DR->INST_Code,
 INS_InsType_DR->INST_Desc
 FROM	PA_AdmInsurance
} ]
{

}
