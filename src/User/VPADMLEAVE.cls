/// View IP Leave details 
Class User.VPADMLEAVE [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 ADML_ParRef,
 ADML_RowId,
 ADML_Reason_DR->RFL_Code,
 ADML_Reason_DR->RFL_Desc,
 ADML_LeaveType_DR->LEATYP_Code,
 ADML_LeaveType_DR->LEATYP_Desc,
 ADML_LeaveCategory_DR->LEACAT_Code,
 ADML_LeaveCategory_DR->LEACAT_Desc,
 ADML_GoingOutDate,
 ADML_GoingOutTime,
 ADML_ExpectedDateReturn,
 ADML_ExpectedTimeReturn,
 ADML_ActualDateReturn,
 ADML_ActualTimeReturn
 FROM	PA_AdmLeave
} ]
{

}
