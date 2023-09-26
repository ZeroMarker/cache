/// Created By HZY 2012-10-18
Class web.DHCEQCLendType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT LT_Desc,
	   LT_RowID,
	   LT_Code
FROM sqluser.DHC_EQCLendType
where LT_InvalidFlag = 'N' and LT_Desc like nvl(:para,'')||'%'
}

}
