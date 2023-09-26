/// Created By HZY 2012-10-18
Class web.DHCEQCLandPurpose Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT LP_Desc,
	   LP_RowID,
	   LP_Code
FROM sqluser.DHC_EQCLandPurpose
where LP_InvalidFlag = 'N' and LP_Desc like nvl(:para,'')||'%'
}

}
