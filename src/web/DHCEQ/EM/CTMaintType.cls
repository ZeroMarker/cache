Class web.DHCEQ.EM.CTMaintType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query MaintType(MaintTypeDesc, MaintType) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT MT_Desc,
	   MT_RowID,
	   MT_Code
FROM sqluser.DHC_EQCMaintType
where MT_InvalidFlag = 'N' and MT_Desc like nvl(:MaintTypeDesc,'')||'%' and MT_Type =:MaintType
}

}
