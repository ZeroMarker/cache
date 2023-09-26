Class DHCEPRFS.INST.RoleResourceLink Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String;

/// 资源ID
Property ResourceID As %String;

/// 资源类型
Property ResourceTypeCode As %String;

/// 操作编码
Property OperationCode As %String;

Index IdxRoleResourceType On (RoleID, ResourceTypeCode);

Storage Default
{
<Data name="RoleResourceLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>ResourceID</Value>
</Value>
<Value name="4">
<Value>ResourceTypeCode</Value>
</Value>
<Value name="5">
<Value>OperationCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.RoleResLinkD</DataLocation>
<DefaultData>RoleResourceLinkDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.RoleResLinkD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.RoleResLinkI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.RoleResLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
