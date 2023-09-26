Class web.DHCEQ.BA.CTResourceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetResourceType(para) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT RT_Desc,
	   RT_RowID,
	   RT_Code
FROM sqluser.DHC_EQCResourceType
where RT_InvalidFlag = 'N' and RT_Desc like nvl(:para,'')||'%'
}

}
