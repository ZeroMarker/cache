/// 名称:EMRmeta.Template
/// 描述:文档模板主表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.Template Extends (%Persistent, User.Abstract)
{

Index TplGuidIdx On GUID [ Unique ];

Index IndexCategoryId On TemplateCategoryID;

/// DOC GRID
Property DocumentType As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

/// EMRmeta.CTProperty
Property TemplateProperty As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

Property TemplateCategoryID As %String(TRUNCATE = 1);

/// the GroupName from EMRmeta.TemplatePriv.TemplateGroup
/// one template can be only set to one template group
/// see method TemplateGroupNameGet()
Property TemplateGroupName As %String(TRUNCATE = 1) [ Calculated, ReadOnly ];

/// 模板模板标识符Code 遵循电子病历基本架构中业务活动记录EMRxxx
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 类型编码(港大自主编码)
Property TypeCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板描述 DisplayName
Property DisplayName As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="TemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindPrintName</Value>
</Value>
<Value name="3">
<Value>BindPrintTemplateID</Value>
</Value>
<Value name="4">
<Value>ChartItemType</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>GUID</Value>
</Value>
<Value name="7">
<Value>LastVersion</Value>
</Value>
<Value name="8">
<Value>PublishVersion</Value>
</Value>
<Value name="9">
<Value>TemplateCategoryID</Value>
</Value>
<Value name="10">
<Value>Code</Value>
</Value>
<Value name="11">
<Value>DisplayName</Value>
</Value>
<Value name="12">
<Value>TPCode</Value>
</Value>
<Value name="13">
<Value>TPDisplayName</Value>
</Value>
<Value name="14">
<Value>TemplateType</Value>
</Value>
<Value name="15">
<Value>Name</Value>
</Value>
<Value name="16">
<Value>TemplateProperty</Value>
</Value>
<Value name="17">
<Value>DocumentType</Value>
</Value>
<Value name="18">
<Value>PropertyCode</Value>
</Value>
<Value name="19">
<Value>PropertyName</Value>
</Value>
<Value name="20">
<Value>TypeCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateD</DataLocation>
<DefaultData>TemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemplateD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
