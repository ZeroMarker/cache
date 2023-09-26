Class web.DHCEQCFromToDept Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT FTD_Desc,
	   FTD_RowID,
	   FTD_Code
FROM sqluser.DHC_EQCFromToDept
where FTD_InvalidFlag = 'N' and FTD_Desc like nvl(:para,'')||'%'
}

}
