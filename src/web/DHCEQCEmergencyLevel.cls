Class web.DHCEQCEmergencyLevel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT EL_Desc,
	   EL_RowID,
	   EL_Code
FROM sqluser.DHC_EQCEmergencyLevel
where EL_InvalidFlag = 'N' and EL_Desc like nvl(:para,'')||'%'
}

}
