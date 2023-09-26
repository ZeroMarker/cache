/// 讨论内容
Class EPRinstance.Quality.OutPatDiscussInfo Extends %Persistent
{

// 讨论日期索引

Index IdxDiscussDates On DiscussDates;

// 讨论意见

Property Idea As %String;

// 讨论日期段

Property DiscussDates As %String(MAXLEN = 200);

// 提交日期

Property submitDate As %String;

Storage Default
{
<Data name="DHCEPRQ.OutPatDiscussInfoD">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>submitDate</Value>
</Value>
<Value name="2">
<Value>DiscussDates</Value>
</Value>
</Data>
<Data name="OutPatDiscussInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Idea</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.OutPatDiscussInfoD</DataLocation>
<DefaultData>DHCEPRQ.OutPatDiscussInfoD</DefaultData>
<IdLocation>^DHCEPRQ.OutPatDiscussInfoD</IdLocation>
<IndexLocation>^DHCEPRQ.OutPatDiscussInfoI</IndexLocation>
<StreamLocation>^DHCEPRQ.OutPatDiscussInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
