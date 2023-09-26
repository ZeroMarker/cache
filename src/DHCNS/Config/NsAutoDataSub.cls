/// creator:lulin
/// createdate:2019-12-15
/// description:系统自动获取数据明细表
Class DHCNS.Config.NsAutoDataSub Extends %Persistent
{

Relationship Parref As DHCNS.Config.NsAutoData [ Cardinality = parent, Inverse = ChildSub ];

/// 数据唯一识别码
Property KeyWord As %String [ SqlColumnNumber = 2, SqlFieldName = KeyWord ];

/// 数据
Property SubDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SubDesc ];

Index keyWord On (Parref, KeyWord);

Storage Default
{
<Data name="NsAutoDataSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyWord</Value>
</Value>
<Value name="3">
<Value>SubDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoDataSubD</DataLocation>
<DefaultData>NsAutoDataSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoDataSubI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoDataSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
