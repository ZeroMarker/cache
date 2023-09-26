/// 名称:EMRmeta.CTOrganizationSchemeItem
/// 描述:患者完整病历内容的组织方案明细项目代码表
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRmeta.CTOrganizationSchemeItem Extends (%Persistent, User.Abstract)
{

Property ItemCode As %String;

Property ItemName As %String;

/// EMRmeta.EMRTemplateCategory
Property EMRTemplateCategoryID As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemTitle As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemURL As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemParas As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ItemType As %String;

Property StartDate As %Date;

Property StartTime As %Time;

Property EndDate As %Date;

Property EndTime As %Time;

Property imagePath As %String;

Index IdxItemCode On ItemCode [ Unique ];

Index IdxEMRTemplateCategoryID On EMRTemplateCategoryID;

Storage Default
{
<Data name="CTOrgSchemeItemDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>imagePath</Value>
</Value>
<Value name="2">
<Value>ItemType</Value>
</Value>
</Data>
<Data name="CTOrganizationSchemeItemDefaultData">
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
<Value>EMRTemplateCategoryID</Value>
</Value>
<Value name="5">
<Value>ItemTitle</Value>
</Value>
<Value name="6">
<Value>ItemURL</Value>
</Value>
<Value name="7">
<Value>ItemParas</Value>
</Value>
<Value name="8">
<Value>StartDate</Value>
</Value>
<Value name="9">
<Value>StartTime</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CTOrgSchemeItemD</DataLocation>
<DefaultData>CTOrgSchemeItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CTOrgSchemeItemD</IdLocation>
<IndexLocation>^DHCEMRM.CTOrgSchemeItemI</IndexLocation>
<StreamLocation>^DHCEMRM.CTOrgSchemeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
