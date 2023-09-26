/// View Patient Allergy 
Class User.VPAAllergy [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 ALG_PAPMI_ParRef,
 ALG_Type_DR,
 ALG_Type_DR->ALG_Desc
 FROM	PA_Allergy
} ]
{

}
