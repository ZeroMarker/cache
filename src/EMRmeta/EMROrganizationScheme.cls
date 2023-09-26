/// 名称:EMRmeta.EMROrganizationScheme
/// 描述:患者完整病历内容的组织方案定义
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRmeta.EMROrganizationScheme Extends (%Persistent, %XML.Adaptor)
{

/// 方案编码
Property SchemeCode As %String;

/// 方案名称
Property SchemeName As %String;

Property CreateUserID As %String;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

/// 显示次序
Property SchemSeq As %Integer;

Relationship SchemType As EMRmeta.EMROrganizationSchemeType [ Cardinality = children, Inverse = ParScheme ];

Storage Default
{
<Data name="EMROrganizationSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeCode</Value>
</Value>
<Value name="3">
<Value>SchemeName</Value>
</Value>
<Value name="4">
<Value>CreateUserID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>ModifyDate</Value>
</Value>
<Value name="8">
<Value>ModifyTime</Value>
</Value>
<Value name="9">
<Value>SchemSeq</Value>
</Value>
<Value name="10">
<Value>SchemType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMROrgSchemeD</DataLocation>
<DefaultData>EMROrgSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMROrgSchemeD</IdLocation>
<IndexLocation>^DHCEMRM.EMROrgSchemeI</IndexLocation>
<StreamLocation>^DHCEMRM.EMROrgSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
