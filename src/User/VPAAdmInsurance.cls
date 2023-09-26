/// View Patient Admission Insurance 
Class User.VPAAdmInsurance [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 INS_RowID,
 INS_PARREF,
 INS_InsType_DR->INST_Code,
 INS_InsType_DR->INST_Desc
 FROM	PA_AdmInsurance
} ]
{

}
