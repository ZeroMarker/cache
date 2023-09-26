/// 名称:EMRmeta.EMROrganizationScheme
/// 描述:患者完整病历内容的组织方案明细项目定义
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRmeta.EMROrganizationSchemeDetails Extends (%Persistent, %XML.Adaptor)
{

Property ItemCode As %String;

Property ItemName As %String;

/// EMRmeta.CTOrganizationSchemeItem.ID
Property ItemDr As %String;

Property ItemSeq As %Integer;

Relationship ParSchemeType As EMRmeta.EMROrganizationSchemeType [ Cardinality = parent, Inverse = Details ];

Index IdxItemSeq On (ParSchemeType, ItemSeq);

Storage Default
{
<Data name="EMROrganizationSchemeDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>ItemDr</Value>
</Value>
<Value name="5">
<Value>ItemSeq</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Details")</DataLocation>
<DefaultData>EMROrganSchemeDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Details")</IdLocation>
<IndexLocation>^DHCEMRM.EMROrgSchemeDetailsI</IndexLocation>
<StreamLocation>^DHCEMRM.EMROrgSchemeDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
