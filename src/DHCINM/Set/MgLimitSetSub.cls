/// Creator:
/// Descriptions:菜单权限子表
/// Date:
Class DHCINM.Set.MgLimitSetSub Extends %Persistent
{

Relationship parref As DHCINM.Set.MgLimitSet [ Cardinality = parent, Inverse = ChildSub, Required ];

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
<DataLocation>^DHCINM.Set.MgLimitSetSubD</DataLocation>
<DefaultData>MgLimitSetSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Set.MgLimitSetSubI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgLimitSetSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
