/// creator:lulin
/// createdate:2019-12-02
/// description:指标配置-类别类
Class CT.DHCNS.Config.NsTypeSet Extends %Persistent
{

/// 编码
Property Code As %String [ SqlColumnNumber = 2, SqlFieldName = Code ];

/// 描述
Property TypeDesc As %String [ SqlColumnNumber = 3, SqlFieldName = TypeDesc ];

/// 状态
Property Status As %String [ SqlColumnNumber = 4, SqlFieldName = Status ];

/// 说明
Property Remark As %String [ SqlColumnNumber = 5, SqlFieldName = Remark ];

Index Code On Code [ Unique ];

Index Desc On TypeDesc;

Storage Default
{
<Data name="NsTypeSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>TypeDesc</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CT.DHCNS.Config.NsTypeSetD</DataLocation>
<DefaultData>NsTypeSetDefaultData</DefaultData>
<IdLocation>^CT.DHCNS.Config.NsTypeSetD</IdLocation>
<IndexLocation>^CT.DHCNS.Config.NsTypeSetI</IndexLocation>
<StreamLocation>^CT.DHCNS.Config.NsTypeSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
