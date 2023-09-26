/// creator:lulin
/// createdate:2019-12-04
/// description:敏感指标-指标配置-元素类别类型
Class DHCNS.Config.NsEleType Extends %Persistent
{

Relationship Parref As DHCNS.Config.NsElement [ Cardinality = parent, Inverse = NsEleType ];

/// 统计项目大类唯一标识 如医嘱ID等
Property TypeID As %String [ SqlColumnNumber = 2, SqlFieldName = TypeID ];

/// 统计项目子类唯一标识【忽略】
Property TypeSubID As %String [ SqlColumnNumber = 3, SqlFieldName = TypeSubID ];

/// 统计项目大类描述
Property TypeDesc As %String [ SqlColumnNumber = 4, SqlFieldName = TypeDesc ];

Index itm On (Parref, TypeID);

Index itmSub On (Parref, TypeID, TypeSubID);

Storage Default
{
<Data name="NsEleTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeID</Value>
</Value>
<Value name="3">
<Value>TypeSubID</Value>
</Value>
<Value name="4">
<Value>TypeDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsEleTypeD</DataLocation>
<DefaultData>NsEleTypeDefaultData</DefaultData>
<IdLocation>{%%PARENT}("NsEleType")</IdLocation>
<IndexLocation>^DHCNS.Config.NsEleTypeI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsEleTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
