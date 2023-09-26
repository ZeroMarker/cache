Class web.DHCEQCDepreType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DT_Desc,
	   DT_RowID,
	   DT_Code
FROM sqluser.DHC_EQCDepreType
where DT_InvalidFlag = 'N' and DT_Desc like nvl(:para,'')||'%'
}

ClassMethod GetDepreTypesInfo()
{
	s infos=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCDepreType",rowid)) q:rowid=""  d
	.i infos'="" s infos=infos_"&"
	.q:$p($g(^DHCEQCCode("DHCEQCDepreType",rowid)),"^",4)'="N"
	.s infos=infos_$g(^DHCEQCCode("DHCEQCDepreType",rowid))_"^"_rowid
	q infos
}

}
