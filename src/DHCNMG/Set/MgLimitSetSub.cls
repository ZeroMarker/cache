Class DHCNMG.Set.MgLimitSetSub Extends %Persistent
{

Relationship parref As DHCNMG.Set.MgLimitSet [ Cardinality = parent, Inverse = ChildSub, Required ];

/// 菜单ID
Property MenuID As %String [ SqlColumnNumber = 2, SqlFieldName = MenuID ];

/// 元素
Property Elements As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Elements ];

Index Sort On parref;

Index Menu On (parref, MenuID);

Storage Default
{
<Data name="MgLimitSetSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuID</Value>
</Value>
<Value name="3">
<Value>Elements</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgLimitSetSubD</DataLocation>
<DefaultData>MgLimitSetSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgLimitSetSubI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgLimitSetSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
