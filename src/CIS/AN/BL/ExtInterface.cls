Class CIS.AN.BL.ExtInterface Extends %Persistent
{

/// 调用接口将手术业务表RowId写入结构化手术
ClassMethod SendSKDOperation(EpisodeID As %String, SKDOperID As %String, OROperID As %String) As %String
{
	s ret=##class(web.DHCBL.MKB.SDSOperationInterface).SaveStructOperation(EpisodeID, SKDOperID, OROperID)
	s flag=$p(ret,"^",1),msg=$p(ret,"^",2)
	s ret=$case(flag,"true":"S","false":"E")_"^"_msg
	q ret
}

/// 调用接口将手术业务表RowId从结构化手术清除
ClassMethod RemoveSKDOperation(ORAnaID As %String) As %String
{
	set EpisodeID=$p(ORAnaID,"||",1),anaSub=$p(ORAnaID,"||",2),operSub=0,saveRet="S^"
	for
	{
		set operSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",operSub))
		quit:(operSub="")
		s ret=##class(web.DHCBL.MKB.SDSOperationInterface).DeleteStructOperation(OROperID)
		s flag=$p(ret,"^",1),msg=$p(ret,"^",2)
		s:(flag="false") saveRet=$case(flag,"true":"S","false":"E")_"^"_msg
		quit:(flag="false")	
	}
	
	q saveRet
}

Storage Default
{
<Data name="ExtInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BL.ExtInterfaceD</DataLocation>
<DefaultData>ExtInterfaceDefaultData</DefaultData>
<IdLocation>^CIS.AN.BL.ExtInterfaceD</IdLocation>
<IndexLocation>^CIS.AN.BL.ExtInterfaceI</IndexLocation>
<StreamLocation>^CIS.AN.BL.ExtInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
