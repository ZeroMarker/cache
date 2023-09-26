/// creator:lulin
/// createdate:2019-12-04
/// description:模板类子表
Class DHCNS.Config.NsModelSub Extends %Persistent
{

Relationship Parref As DHCNS.Config.NsModel [ Cardinality = parent, Inverse = ChildSub ];

/// 关联元素
Property SubProp As %Integer [ SqlColumnNumber = 2, SqlFieldName = SubProp ];

/// 类型:I:指标，E:元素
Property SubType As %String [ SqlColumnNumber = 3, SqlFieldName = SubType ];

/// 排序
Property SubSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = SubSort ];

/// 分类
Property SubClass As %String [ SqlColumnNumber = 5, SqlFieldName = SubClass ];

/// 日描述
Property SubDescD As %String [ SqlColumnNumber = 6, SqlFieldName = SubDescD ];

/// 月描述
Property SubDescM As %String [ SqlColumnNumber = 7, SqlFieldName = SubDescM ];

/// 季描述
Property SubDescQ As %String [ SqlColumnNumber = 8, SqlFieldName = SubDescQ ];

/// 半年描述
Property SubDescH As %String [ SqlColumnNumber = 9, SqlFieldName = SubDescH ];

/// 年描述
Property SubDescY As %String [ SqlColumnNumber = 10, SqlFieldName = SubDescY ];

Index Prop On (SubType, SubProp, Parref);

Index Type On (Parref, SubType);

Index Sort On (Parref, SubSort);

Storage Default
{
<Data name="NsModelSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubProp</Value>
</Value>
<Value name="3">
<Value>SubType</Value>
</Value>
<Value name="4">
<Value>SubSort</Value>
</Value>
<Value name="5">
<Value>SubClass</Value>
</Value>
<Value name="6">
<Value>SubDescD</Value>
</Value>
<Value name="7">
<Value>SubDescM</Value>
</Value>
<Value name="8">
<Value>SubDescQ</Value>
</Value>
<Value name="9">
<Value>SubDescH</Value>
</Value>
<Value name="10">
<Value>SubDescY</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsModelSubD</DataLocation>
<DefaultData>NsModelSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNS.Config.NsModelSubI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsModelSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
