/// 名称:EMRmeta.EpisodeDataItem
/// 描述:就诊数据项表
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRmeta.EpisodeDataItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property DataType As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EpisodeDataItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>DataType</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EpisodeDataItemD</DataLocation>
<DefaultData>EpisodeDataItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EpisodeDataItemD</IdLocation>
<IndexLocation>^DHCEMRM.EpisodeDataItemI</IndexLocation>
<StreamLocation>^DHCEMRM.EpisodeDataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
