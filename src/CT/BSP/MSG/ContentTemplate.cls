/// 消息内容模板
/// 不同于消息模板，消息模板为数据组织模板，定义了消息中的数据变量如何组织称消息内容，而消息内容模板则为内容编辑模板，用户选则模板后，再在模板的基础上具体修改消息内容
Class CT.BSP.MSG.ContentTemplate Extends %Persistent
{

/// Template模板,Draft草稿,TemplateCatgory模板分类,DraftCatgory草稿分类
Property Type As %String(COLLATION = "Exact", DISPLAYLIST = ",Template,Draft,TemplateCatgory,DraftCatgory", TRUNCATE = 1, VALUELIST = ",T,D,TC,DC") [ Required ];

Property Catgory As ContentTemplate;

Property Title As %String;

Property Summary As %String(MAXLEN = 500);

Property Content As %Stream.GlobalCharacter;

/// 所属类型
Property RefType As %String(COLLATION = "Exact", DISPLAYLIST = ",Site,Hospital,Group,Location,User", TRUNCATE = 1, VALUELIST = ",S,H,G,L,U") [ Required ];

/// 所属对象ID
Property RefObjId As %String(COLLATION = "Exact") [ Required ];

Property UpdateUser As %String;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Index TypeRefCat On (Type, RefType, RefObjId, Catgory);

Storage Default
{
<Data name="ContentTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Catgory</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
<Value name="5">
<Value>Summary</Value>
</Value>
<Value name="6">
<Value>Content</Value>
</Value>
<Value name="7">
<Value>RefType</Value>
</Value>
<Value name="8">
<Value>RefObjId</Value>
</Value>
<Value name="9">
<Value>UpdateUser</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.MSG.ContentTemplateD</DataLocation>
<DefaultData>ContentTemplateDefaultData</DefaultData>
<IdLocation>^CT.BSP.MSG.ContentTemplateD</IdLocation>
<IndexLocation>^CT.BSP.MSG.ContentTemplateI</IndexLocation>
<StreamLocation>^CT.BSP.MSG.ContentTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
