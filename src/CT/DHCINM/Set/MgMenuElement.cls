/// Creator:
/// Descriptions:系统设置-菜单元素表
/// Date:
Class CT.DHCINM.Set.MgMenuElement Extends %Persistent
{

Relationship Parref As CT.DHCINM.Set.MgMenu [ Cardinality = parent, Inverse = ChildSub ];

/// 元素ID
Property ElementCode As %String [ SqlColumnNumber = 2, SqlFieldName = Element_Code ];

/// 元素Text
Property ElementDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Element_Desc ];

/// 元素类型
Property ElementType As %String [ SqlColumnNumber = 4, SqlFieldName = Element_Type ];

Index Code On (Parref, ElementCode);

Storage Default
{
<Data name="MgMenuElementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElementCode</Value>
</Value>
<Value name="3">
<Value>ElementDesc</Value>
</Value>
<Value name="4">
<Value>ElementType</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgMenuElementD</DataLocation>
<DefaultData>MgMenuElementDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgMenuElementI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgMenuElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
