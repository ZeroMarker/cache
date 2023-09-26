Class EPRmeta.EPRMessageType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作编码
Property ActionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 操作名称
Property ActionName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 是否有效
Property IsActive As %Boolean [ SqlColumnNumber = 4 ];

Index IdxMain On ActionCode [ Unique ];

Storage Default
{
<Data name="EPRMessageTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.EPRMessageTypeD</DataLocation>
<DefaultData>EPRMessageTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.EPRMessageTypeD</IdLocation>
<IndexLocation>^EPRmeta.EPRMessageTypeI</IndexLocation>
<StreamLocation>^EPRmeta.EPRMessageTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
