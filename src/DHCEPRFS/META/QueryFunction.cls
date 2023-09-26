/// Desc: 权限功能字典表
/// Creator:Candy
Class DHCEPRFS.META.QueryFunction Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParentId On ParentID;

Index IdxFuncName On FuncName [ Unique ];

Index IdxNotes On Notes;

/// 功能名称
Property FuncName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 功能描述
Property FuncDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 父节点
Property ParentID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 备注
Property Notes As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 是否可用
Property IsAvailable As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="QueryFunctionDefaultData">
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
<Value>IsAvailable</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryFunctionD</DataLocation>
<DefaultData>QueryFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryFunctionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryFunctionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
