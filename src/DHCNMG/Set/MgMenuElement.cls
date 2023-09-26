/// creator:xbl
/// date:20170714
/// desc:界面元素
Class DHCNMG.Set.MgMenuElement Extends %Persistent
{

Relationship Parref As DHCNMG.Set.MgMenu [ Cardinality = parent, Inverse = ChildSub ];

/// 元素ID
Property ElementCode As %String [ SqlColumnNumber = 4, SqlFieldName = Element_Code ];

/// 元素Text
Property ElementDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Element_Desc ];

/// 元素类型
Property ElementType As %String [ SqlColumnNumber = 6, SqlFieldName = Element_Type ];

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
<DataLocation>^DHCNMG.Set.MgMenuElementD</DataLocation>
<DefaultData>MgMenuElementDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgMenuElementI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgMenuElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
