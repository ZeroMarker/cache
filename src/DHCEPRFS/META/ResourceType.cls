/// 角色资源类型
Class DHCEPRFS.META.ResourceType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 资源类型编码
Property ResourceTypeCode As %String(TRUNCATE = 1);

/// 名称
Property ResourceTypeName As %String(TRUNCATE = 1);

/// 可用操作编码
Property AvailableOperations As %String(TRUNCATE = 1);

Index IdxResourceTypeCode On ResourceTypeCode [ Unique ];

Storage Default
{
<Data name="ResourceTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceTypeCode</Value>
</Value>
<Value name="3">
<Value>ResourceTypeName</Value>
</Value>
<Value name="4">
<Value>AvailableOperations</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceTypeD</DataLocation>
<DefaultData>ResourceTypeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
