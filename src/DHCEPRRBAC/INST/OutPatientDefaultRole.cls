Class DHCEPRRBAC.INST.OutPatientDefaultRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 是否当前使用
Property IsActive As %String(TRUNCATE = 1);

Index IdxActive On IsActive;

Storage Default
{
<Data name="OutPatientDefaultRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.OPDRoleD</DataLocation>
<DefaultData>OutPatientDefaultRoleDefaultData</DefaultData>
<IdLocation>^DHCEPRRBAC.INST.OPDRoleD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.OPDRoleI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.OPDRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
