/// Desc:系统功能项定义表
/// CreateDate:2013-7-19
Class DHCEPRFS.META.CTFunction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParentId On ParentID;

Index IdxFuncName On FuncName;

/// 功能名称
Property FuncName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 功能描述
Property FuncDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 父节点
Property ParentID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Group/Item 
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 备注
Property Notes As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="CTFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FuncDesc</Value>
</Value>
<Value name="3">
<Value>FuncName</Value>
</Value>
<Value name="4">
<Value>Notes</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTFunctionD</DataLocation>
<DefaultData>CTFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.CTFunctionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTFunctionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
