/// Creator:
/// Descriptions:菜单权限主表
/// Date:
Class CT.DHCINM.Set.MgLimitSet Extends %Persistent
{

Relationship ChildSub As CT.DHCINM.Set.MgLimitSetSub [ Cardinality = children, Inverse = parref ];

/// 角色ID
Property RoleID As %String [ SqlColumnNumber = 2, SqlFieldName = RoleID ];

/// 模块
Property MoudID As %String [ SqlColumnNumber = 3, SqlFieldName = MoudID ];

Index sort On (RoleID, MoudID);

Storage Default
{
<Data name="MgLimitSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>MoudID</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgLimitSetD</DataLocation>
<DefaultData>MgLimitSetDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgLimitSetD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgLimitSetI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgLimitSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
