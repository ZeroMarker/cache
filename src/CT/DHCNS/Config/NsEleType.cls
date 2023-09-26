/// creator:lulin
/// createdate:2019-12-04
/// description:敏感指标-指标配置-元素类别类型
Class CT.DHCNS.Config.NsEleType Extends %Persistent
{

Relationship Parref As CT.DHCNS.Config.NsElement [ Cardinality = parent, Inverse = NsEleType ];

/// 统计项目大类唯一标识 如医嘱ID等
Property TypeID As %String [ SqlColumnNumber = 2, SqlFieldName = TypeID ];

/// 统计项目子类唯一标识【忽略】
Property TypeSubID As %String [ SqlColumnNumber = 3, SqlFieldName = TypeSubID ];

/// 统计项目大类描述
Property TypeDesc As %String [ SqlColumnNumber = 4, SqlFieldName = TypeDesc ];

/// 医嘱类型：N:统计(根据此医嘱统计)，P:前置条件，E:排除。M:互斥
Property TypeFlag As %String [ SqlColumnNumber = 5, SqlFieldName = TypeFlag ];

/// 剂量--医嘱
Property DoseQty As %String [ SqlColumnNumber = 6, SqlFieldName = DoseQty ];

/// 剂量单位id--医嘱
Property OrderUnit As %String [ SqlColumnNumber = 7, SqlFieldName = OrderUnit ];

/// 用法，多个逗号隔开--医嘱
Property OrderInstrDR As %String(MAXLEN = 100) [ SqlColumnNumber = 8, SqlFieldName = OrderInstrDR ];

/// 母亲医嘱 ""/N:否，Y:是--医嘱
Property MotherFlag As %String [ SqlColumnNumber = 9, SqlFieldName = MotherFlag ];

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
<Value name="5">
<Value>TypeFlag</Value>
</Value>
<Value name="6">
<Value>DoseQty</Value>
</Value>
<Value name="7">
<Value>OrderUnit</Value>
</Value>
<Value name="8">
<Value>OrderInstrDR</Value>
</Value>
<Value name="9">
<Value>MotherFlag</Value>
</Value>
</Data>
<DataLocation>^CT.DHCNS.Config.NsEleTypeD</DataLocation>
<DefaultData>NsEleTypeDefaultData</DefaultData>
<IdLocation>{%%PARENT}("NsEleType")</IdLocation>
<IndexLocation>^CT.DHCNS.Config.NsEleTypeI</IndexLocation>
<StreamLocation>^CT.DHCNS.Config.NsEleTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
