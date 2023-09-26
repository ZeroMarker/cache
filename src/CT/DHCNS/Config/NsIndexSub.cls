/// creator:lulin
/// createdate:2019-12-04
/// description:指标子表
Class CT.DHCNS.Config.NsIndexSub Extends %Persistent
{

Relationship Parref As CT.DHCNS.Config.NsIndex [ Cardinality = parent, Inverse = ChildSub ];

/// 关联元素
Property SubProp As CT.DHCNS.Config.NsElement [ SqlColumnNumber = 2, SqlFieldName = SubProp ];

/// 类型:分子:N,分子排除:NR,分母:D,分母排除:DR
Property SubType As %String [ SqlColumnNumber = 3, SqlFieldName = SubType ];

Index Prop On (SubProp, Parref);

Index Type On (Parref, SubType);

Storage Default
{
<Data name="NsIndexSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubProp</Value>
</Value>
<Value name="3">
<Value>SubType</Value>
</Value>
</Data>
<DataLocation>^CT.DHCNS.Config.NsIndexSubD</DataLocation>
<DefaultData>NsIndexSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCNS.Config.NsIndexSubI</IndexLocation>
<StreamLocation>^CT.DHCNS.Config.NsIndexSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
