/// 名称:EMRmeta.TemplateCategory
/// 描述:文档模板目录表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.TemplateCategory Extends (%Persistent, User.Abstract)
{

Index IdxParentId On ParentID;

//Index IdxCategoryProperty On CategoryProperty;

/// EMRmeta.CTProperty
Property PropertyCode As %String(TRUNCATE = 1);

Property PropertyName As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Storage Default
{
<Data name="TemplateCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryProperty</Value>
</Value>
<Value name="3">
<Value>CategoryType</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>ResChildCount</Value>
</Value>
<Value name="8">
<Value>PropertyCode</Value>
</Value>
<Value name="9">
<Value>PropertyName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateCategoryD</DataLocation>
<DefaultData>TemplateCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemplateCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
