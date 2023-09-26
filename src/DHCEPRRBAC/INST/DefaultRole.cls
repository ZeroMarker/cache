Class DHCEPRRBAC.INST.DefaultRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 安全组ID
Property SSGroupID As %String(TRUNCATE = 1);

Index IdxSSGroupID On SSGroupID;

Index IdxRoleID On RoleID;

Index IdxSSGroupRoleID On (SSGroupID, RoleID);

Storage Default
{
<Data name="DefaultRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.DefaultRoleD</DataLocation>
<DefaultData>DefaultRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.DefaultRoleD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.DefaultRoleI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.DefaultRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
