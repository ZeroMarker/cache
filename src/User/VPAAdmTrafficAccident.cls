/// View Traffic Accident
Class User.VPAAdmTrafficAccident [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 TRF_RowId,
 TRF_AccidentCode_DR->TRF_Code,
 TRF_AccidentCode_DR->TRF_Desc,
 TRF_AccidentDate,
 TRF_AccidentTime,
 TRF_VehInsPolicy,
 TRF_Injury,
 TRF_InformedEmployer,
 TRF_Place,
 TRF_VehReq,
 TRF_VehReq2,
 TRF_VehReq3,
 TRF_PatientRole_DR->PATROL_Desc,
 TRF_LocationInj_DR->LOCINJ_Desc		
 FROM	PA_TrafficAccident
} ]
{

}
