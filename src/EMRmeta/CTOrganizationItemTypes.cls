/// 名称:EMRmeta.CTOrganizationItemTypes
/// 描述:方案明细项目类型表
/// 编写者：yejian
/// 编写日期:2017-7-6
Class EMRmeta.CTOrganizationItemTypes Extends %Persistent
{

Property TypeName As %String;

Property TypeDescription As %String;

Storage Default
{
<Data name="CTOrganizationItemTypesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeName</Value>
</Value>
<Value name="3">
<Value>TypeDescription</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CTOrgItemTypesD</DataLocation>
<DefaultData>CTOrganizationItemTypesDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CTOrgItemTypesD</IdLocation>
<IndexLocation>^DHCEMRM.CTOrgItemTypesI</IndexLocation>
<StreamLocation>^DHCEMRM.CTOrgItemTypesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
