/// Creator:
/// Descriptions:权限设置
/// Date:2017-11-13
/// 
Class DHCNMG.Set.MgLimitSet Extends %Persistent
{

Relationship ChildSub As DHCNMG.Set.MgLimitSetSub [ Cardinality = children, Inverse = parref ];

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
<DataLocation>^DHCNMG.Set.MgLimitSetD</DataLocation>
<DefaultData>MgLimitSetDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgLimitSetD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgLimitSetI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgLimitSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
