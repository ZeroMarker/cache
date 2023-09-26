/// 门诊患者病历抽查日期
Class EPRinstance.Quality.OutPatSpotCheckDate Extends %Persistent
{

// 最后一次抽查索引

Index IdxLastSpotCheck On LastSpotCheck;

// 抽查日期索引

Index IdxSpotCheckDate On SpotCheckDate;

// 开始时间

Property StartDate As %String;

// 结束时间

Property EndDate As %String;

// 抽查日期

Property SpotCheckDate As %String;

// 最后一次抽查

Property LastSpotCheck As %String;

Storage Default
{
<Data name="DHCEPRQ.OutPatSpotCheckDateD">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>LastSpotCheck</Value>
</Value>
</Data>
<Data name="OutPatSpotCheckDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>SpotCheckDate</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.OutPatSpotCheckDateD</DataLocation>
<DefaultData>DHCEPRQ.OutPatSpotCheckDateD</DefaultData>
<IdLocation>^DHCEPRQ.OutPatSpotCheckDateD</IdLocation>
<IndexLocation>^DHCEPRQ.OutPatSpotCheckDateI</IndexLocation>
<StreamLocation>^DHCEPRQ.OutPatSpotCheckDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
