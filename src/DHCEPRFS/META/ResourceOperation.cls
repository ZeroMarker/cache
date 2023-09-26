/// Desc: 角色操作功能
Class DHCEPRFS.META.ResourceOperation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作编码
Property OperationCode As %String(TRUNCATE = 1);

/// 操作名称
Property OperationDesc As %String(TRUNCATE = 1);

/// 有效标志
Property IsValid As %String(TRUNCATE = 1);

Index IdxOperationCode On OperationCode [ Unique ];

Storage Default
{
<Data name="ResourceOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperationCode</Value>
</Value>
<Value name="3">
<Value>OperationDesc</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceOperaD</DataLocation>
<DefaultData>ResourceOperationDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceOperaD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceOperaI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceOperaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
