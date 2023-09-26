Import SQLUser

Class web.DHCEQCCurrency Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT C_Desc,
	   C_RowID,
	   C_Code
FROM sqluser.DHC_EQCCurrency
where C_InvalidFlag = 'N' and C_Desc like nvl(:para,'')||'%'
}

}
