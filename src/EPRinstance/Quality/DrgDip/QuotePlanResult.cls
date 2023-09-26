Class EPRinstance.Quality.DrgDip.QuotePlanResult Extends %Persistent
{

Property EpisodeID As %String;

Property Type As %String;

Property Code As %String;

Property Value As %String;

Index IdxEpisodeIDType On (EpisodeID, Type);

Index IdxEpisodeID On EpisodeID;

/// 依据DIAG 与 OPER，分别加载引用的DRGDIP数据
/// item1$item2$item3
/// item: code^value
/// 主要诊断和主要手术均为返回数据的第一项。
/// w ##Class(EPRinstance.Quality.DrgDip.QuotePlanResult).GetDrgDipByType(285,"DIAG")
ClassMethod GetDrgDipByType(AEpisodeID As %String, AType As %String)
{
	s result=""
	q:(AEpisodeID="") result
	s resultList=""
	s tmpId=""
	for
	{
		s tmpId = $o(^DHCEPRQ.QuotePlanResultI("IdxEpisodeIDType"," "_AEpisodeID," "_AType,tmpId))
		q:(tmpId="")
		
		s obj = ##class(EPRinstance.Quality.DrgDip.QuotePlanResult).%OpenId(tmpId)
		continue:(obj="")
		s code=obj.Code
		s value=obj.Value
		s item = code_"^"_value
		s resultList=resultList_$lb(item)
	}
	s result = $lts(resultList,"$")
	q result
}

Storage Default
{
<Data name="QuotePlanResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QuotePlanResultD</DataLocation>
<DefaultData>QuotePlanResultDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.QuotePlanResultD</IdLocation>
<IndexLocation>^DHCEPRQ.QuotePlanResultI</IndexLocation>
<StreamLocation>^DHCEPRQ.QuotePlanResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
