/// 名称:EMRmeta.EMRNavigationSchemeItem
/// 描述:患者完整病历内容的组织方案明细项目定义
/// 编写者：yejian
/// 编写日期: 2016-5-16
Class EMRmeta.EMRNavigationSchemeItem Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.EMRNavigationScheme表SchemeCode关联
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem表ItemCode关联
Property ItemCode As %String;

Property ItemName As %String;

/// EMRmeta.CTOrganizationSchemeItem.ID
Property ItemDr As %String;

Property ItemSeq As %Integer;

Index IdxSchemeItemCode On (SchemeCode, ItemCode) [ Unique ];

Index IdxItemSeq On (SchemeCode, ItemSeq);

Storage Default
{
<Data name="EMRNavigationSchemeItemDefaultData">
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
<Value>ItemDr</Value>
</Value>
<Value name="6">
<Value>ItemSeq</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavSchemeItemD</DataLocation>
<DefaultData>EMRNavigationSchemeItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavSchemeItemD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavSchemeItemI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavSchemeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
