/// 质控员总结
Class EPRinstance.Quality.OutPatSummaryInfo Extends %Persistent
{

// 提交日期索引

Index IdxSubmitDate On submitDate;

// 总结日期段索引

Index IdxSummaryDate On SummaryDate;

// 总结

Property Summary As %String;

// 提交日期

Property submitDate As %String;

// 总结内容对应日期

Property SummaryDate As %String;

Storage Default
{
<Data name="DHCEPRQ.OutPatSummaryInfoD">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>SummaryDate</Value>
</Value>
</Data>
<Data name="OutPatSummaryInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Summary</Value>
</Value>
<Value name="3">
<Value>submitDate</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.OutPatSummaryInfoD</DataLocation>
<DefaultData>DHCEPRQ.OutPatSummaryInfoD</DefaultData>
<IdLocation>^DHCEPRQ.OutPatSummaryInfoD</IdLocation>
<IndexLocation>^DHCEPRQ.OutPatSummaryInfoI</IndexLocation>
<StreamLocation>^DHCEPRQ.OutPatSummaryInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
