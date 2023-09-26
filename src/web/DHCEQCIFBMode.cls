Import SQLUser

Class web.DHCEQCIFBMode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT IFBM_Desc,
	   IFBM_RowID,
	   IFBM_Code
FROM sqluser.DHC_EQCIFBMode
where IFBM_InvalidFlag = 'N' and IFBM_Desc like nvl(:para,'')||'%'
}

}
