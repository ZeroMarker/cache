/// 描述:       短语目录
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.TemplateCategory Extends %Persistent
{

/// 目录名称
Property Name As %String;

/// 目录类型
Property Type As %String;

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 是否有效
Property IsValid As %String;

/// 创建者UserID
Property UserID As %String;

Index IdxUserID On UserID;

Storage Default
{
<Data name="TemplateCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsValid</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.TemplateCategoryD</DataLocation>
<DefaultData>TemplateCategoryDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.TemplateCategoryD</IdLocation>
<IndexLocation>^CT.BSP.GBP.TemplateCategoryI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.TemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
