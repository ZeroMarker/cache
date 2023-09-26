Class User.MKBStructIndex Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_SrtuctIndex ]
{

/// ID串  数据处理工厂父表id
Property MKBSICode As %String(MAXLEN = "");

/// 描述
Property MKBSIDesc As %String(MAXLEN = "");

/// 数据处理工厂或各版本ICD对照指向
/// 数据处理工厂指向存工厂注册id，各版本ICD对照指向存ICD+ICD版本id
Property MKBSIBase As %String;

Index DescIndex On (MKBSIBase As Exact, MKBSIDesc, MKBSICode As Exact);

/// 20210415用于根据数据处理工厂ID删除索引
Index CodeIndex On (MKBSIBase As Exact, MKBSICode As Exact);

Storage Default
{
<Data name="MKBStructIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSICode</Value>
</Value>
<Value name="3">
<Value>MKBSIDesc</Value>
</Value>
<Value name="4">
<Value>MKBSIBase</Value>
</Value>
</Data>
<DataLocation>^User.MKBStructIndexD</DataLocation>
<DefaultData>MKBStructIndexDefaultData</DefaultData>
<IdLocation>^User.MKBStructIndexD</IdLocation>
<IndexLocation>^User.MKBStructIndexI</IndexLocation>
<StreamLocation>^User.MKBStructIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
