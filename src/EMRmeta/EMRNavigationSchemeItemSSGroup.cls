/// 名称: EMRmeta.EMRNavigationSchemeItemSSGroup
/// 描述: 患者完整病历内容的组织方案项目安全组配置(安全组)
/// 编写者：yejian	
/// 编写日期: 2016-5-16
Class EMRmeta.EMRNavigationSchemeItemSSGroup Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.EMRNavigationScheme表的SchemeCode
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem中的ItemCode关联
Property ItemCode As %String;

/// 方案项名称(冗余字段)
Property ItemName As %String;

/// 规则条件的ID（只使用安全组，即安全组的ID）
Property SSGroupID As %String(TRUNCATE = 1);

/// 规则条件的描述（只使用安全组，即安全组的名称）
Property SSGroupName As %String(TRUNCATE = 1);

Index IdxCodeSSGroup On (SchemeCode, ItemCode, SSGroupID) [ Unique ];

Storage Default
{
<Data name="EMRNavigationSchemeItemSSGroupDefaultData">
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
<Value>SSGroupID</Value>
</Value>
<Value name="6">
<Value>SSGroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavItemSSGroupD</DataLocation>
<DefaultData>EMRNavigationSchemeItemSSGroupDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavItemSSGroupD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavItemSSGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavItemSSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
