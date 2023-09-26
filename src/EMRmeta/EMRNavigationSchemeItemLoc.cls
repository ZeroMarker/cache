/// 名称: EMRmeta.EMROrganizationItemLoc
/// 描述: 患者完整病历内容的组织方案项目科室配置(科室)
/// 编写者：yejian	
/// 编写日期: 2016-5-16
Class EMRmeta.EMRNavigationSchemeItemLoc Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.EMRNavigationScheme表的SchemeCode
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem表的ItemCode
Property ItemCode As %String;

/// 方案项名称(冗余字段)
Property ItemName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

Index IdxCodeCTLocID On (SchemeCode, ItemCode, CTLocID) [ Unique ];

Storage Default
{
<Data name="EMRNavigationSchemeItemLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeCode</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>CTLocID</Value>
</Value>
<Value name="6">
<Value>CTLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavItemLocD</DataLocation>
<DefaultData>EMRNavigationSchemeItemLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavItemLocD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavItemLocI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavItemLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
