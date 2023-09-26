/// 名称: CT.WDT.MKB.FunctionalElement
/// 描述: 菜单关联功能元素表
/// 编写者：谷雪萍
/// 编写日期: 2021-11-23
Class CT.WDT.MKB.FunctionalElement Extends (%Persistent, User.Abstract)
{

Relationship ParRef As CT.WDT.MKB.Menu [ Cardinality = parent, Inverse = ChildItem ];

/// 功能元素代码
Property ItemCode As %String(MAXLEN = 200) [ Required ];

/// 功能元素名称
Property ItemName As %String(MAXLEN = 200) [ Required ];

/// 按钮类型
Property ItemType As %String;

Index UnCodeIndex On (ParRef, ItemCode) [ Unique ];

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
<IdLocation>^CT.WDT.MKB.MenuC("ChildItem")</IdLocation>
<IndexLocation>^CT.WDT.MKB.FunctionalElementI</IndexLocation>
<StreamLocation>^CT.WDT.MKB.FunctionalElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
