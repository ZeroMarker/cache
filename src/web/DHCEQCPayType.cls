Class web.DHCEQCPayType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPayType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:para,'')||'%'
}

}
