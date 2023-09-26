/// 名称: CT.BDP.CT.FunctionalElement
/// 描述: 基础数据平台hisui菜单关联功能元素表
/// 编写者：zrf
/// 编写日期: 2023-4-26
Class CT.BDP.CT.FunctionalElement Extends (%Persistent, User.Abstract)
{

Relationship ParRef As User.BDPMenu [ Cardinality = parent, Inverse = ChildItem ];

/// 功能元素代码
Property ItemCode As %String(MAXLEN = 200) [ Required ];

/// 功能元素名称
Property ItemName As %String(MAXLEN = 200) [ Required ];

/// 按钮类型
Property ItemType As %String;

Index UnCodeIndex On (ParRef, ItemCode) [ Unique ];

Index ItemTypeIndex On (ParRef, ItemType);

Storage Default
{
<Data name="FunctionalElementDefaultData">
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
<Value>ItemType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildItem")</DataLocation>
<DefaultData>FunctionalElementDefaultData</DefaultData>
<IdLocation>^User.BDPMenuC("ChildItem")</IdLocation>
<IndexLocation>^CT.BDP.CT.FunctionalElementI</IndexLocation>
<StreamLocation>^CT.BDP.CT.FunctionalElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
