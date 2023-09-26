/// Desc:角色功能资源
Class DHCEPRFS.META.ResourceFunc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 功能编码
Property FuncCode As %String(TRUNCATE = 1);

/// 功能名称
Property FuncName As %String(TRUNCATE = 1);

/// 排序码
Property Sequence As %String(TRUNCATE = 1);

/// 有效标志
Property IsValid As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ResourceFuncDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FuncCode</Value>
</Value>
<Value name="3">
<Value>FuncName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceFuncD</DataLocation>
<DefaultData>ResourceFuncDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceFuncD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceFuncI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceFuncS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
