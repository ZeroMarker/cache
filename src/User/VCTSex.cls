/// View for Sex Codes
Class User.VCTSex [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT  
 CTSEX_RowID,
 CTSEX_Code as Code		
 FROM	CT_Sex
 wHERE	CTSEX_RowID<2
} ]
{

}
