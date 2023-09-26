/// 描述:病历项目生成调用方式
Class DHCEPRFS.META.CTItemInvokeType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 调用方式编码
/// CreateType01--生成接口方式为csp ; CreateType02--生成接口方式为exe ; CreateType03--生成接口方式为ftp
Property InvokeTypeCode As %String(TRUNCATE = 1);

/// 调用方式名称
Property InvokeTypeName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CTItemInvokeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InvokeTypeCode</Value>
</Value>
<Value name="3">
<Value>InvokeTypeName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTItemInvokeD</DataLocation>
<DefaultData>CTItemInvokeTypeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.CTItemInvokeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTItemInvokeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTItemInvokeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
