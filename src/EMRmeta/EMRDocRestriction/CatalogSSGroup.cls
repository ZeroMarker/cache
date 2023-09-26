/// 名称:EMRmeta.DocRestriction.CatalogSSGroup
/// 描述:病历展现结构-第一级目录权限配置表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.EMRDocRestriction.CatalogSSGroup Extends %Persistent
{

/// 病历显示结构的目录节点ID
Property EMRDocID As %String(TRUNCATE = 1);

/// 规则条件的ID（只使用安全组，即安全组的ID）
Property SSGroupID As %String(TRUNCATE = 1);

/// 规则条件的描述（只使用安全组，即安全组的名称）
Property SSGroupName As %String(TRUNCATE = 1);

Index IdxCatalogSSGroup On (EMRDocID, SSGroupID) [ Unique ];

Storage Default
{
<Data name="CatalogSSGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRDocID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
<Value name="4">
<Value>SSGroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRDOC.EMRSSGroupD</DataLocation>
<DefaultData>CatalogSSGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRDOC.EMRSSGroupD</IdLocation>
<IndexLocation>^DHCEMRM.EMRDOC.EMRSSGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRDOC.EMRSSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
