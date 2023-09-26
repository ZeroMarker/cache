/// 描述：     短语模板
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.Template Extends %Persistent
{

/// 节点名称
Property Name As %String;

/// 别名（拼音简写)
Property Alias As %String(TRUNCATE = 1);

/// 节点描述
Property Description As %String;

/// 父节点EMRmeta.PhraseCategory表的id
Property ParentID As %Integer;

/// 顺序
Property Sequence As %Integer;

/// 是否有效
Property IsValid As %String;

/// 是否可弹出修改选项，1（表单）：可以弹出修改，0（片段）：不可以弹出修改。
Property IsPopUp As %String;

/// 模板类型 TEXT：文本类型，：STRUCTURE不可以弹出修改。
Property TemplateType As %String;

/// 创建者UserID
Property UserID As %String;

/// 创建日期
Property CreateDate As %String;

/// 文本内容（模板类型为TEXT）
Property Content As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 结构化内容
Property MetaData As %GlobalCharacterStream(LOCATION = "^CT.BSP.GBP.TemplateS");

/// 展现内容
Property InstanceData As %GlobalCharacterStream(LOCATION = "^CT.BSP.GBP.TemplateS");

Index IdxParentID On ParentID;

Index IdxUserID On UserID;

Storage Default
{
<Data name="TemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
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
<Value>IsPopUp</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>Content</Value>
</Value>
<Value name="10">
<Value>Alias</Value>
</Value>
<Value name="11">
<Value>UserID</Value>
</Value>
<Value name="12">
<Value>TemplateType</Value>
</Value>
<Value name="13">
<Value>MetaData</Value>
</Value>
<Value name="14">
<Value>InstanceData</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.TemplateD</DataLocation>
<DefaultData>TemplateDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.TemplateD</IdLocation>
<IndexLocation>^CT.BSP.GBP.TemplateI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.TemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
