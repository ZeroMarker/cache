Class DHCEPRRBAC.INST.ResourceRoleItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RoleID As %String(TRUNCATE = 1);

Property OperationID As %String(TRUNCATE = 1);

Property Sequence As %Integer;

Property PrivateDomainID As %String(TRUNCATE = 1);

Property ResourceItemID As %String(TRUNCATE = 1);

Index IdxMain On (RoleID, Sequence);

Index IdxRoleItem On (RoleID, OperationID, Sequence, ResourceItemID);

Index IdexRoleOperation On (RoleID, OperationID);

Index IdxRolePrivateDomain On (RoleID, OperationID, PrivateDomainID);

Storage Default
{
<Data name="ResourceRoleItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>ResourceItemID</Value>
</Value>
<Value name="5">
<Value>OperationID</Value>
</Value>
<Value name="6">
<Value>PrivateDomainID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.ResourceRItemD</DataLocation>
<DefaultData>ResourceRoleItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.ResourceRItemD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.ResourceRItemI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.ResourceRItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
