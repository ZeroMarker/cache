/// 名称: EMRmeta.EMROrganizationSchemeLoc
/// 描述: 患者完整病历内容的组织方案配置表(科室)
/// 编写者：guozongtao	
/// 编写日期: 2014-08-118
Class EMRmeta.EMROrganizationSchemeLoc Extends (%Persistent, %XML.Adaptor)
{

Property SchemeID As %String;

/// 方案名称(冗余字段)
Property SchemeName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

Index IdxCTLocIDSchemeID On (CTLocID, SchemeID);

Index IdxSchemeID On SchemeID;

Storage Default
{
<Data name="EMROrganizationSchemeLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeID</Value>
</Value>
<Value name="3">
<Value>SchemeName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMROrgSchemeLocD</DataLocation>
<DefaultData>EMROrgSchemeLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMROrgSchemeLocD</IdLocation>
<IndexLocation>^DHCEMRM.EMROrgSchemeLocI</IndexLocation>
<StreamLocation>^DHCEMRM.EMROrgSchemeLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
