/// 安全组
Class DHCCL.Code.SecureGroup Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SecureGroup ]
{

/// 安全组代码
Property Code As %String [ SqlColumnNumber = 2 ];

/// 安全组名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index ExtID On ExternalID As Exact;

Storage Default
{
<Data name="SecureGroupDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.SecureGroupD</DataLocation>
<DefaultData>SecureGroupDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.SecureGroupD</IdLocation>
<IndexLocation>^DHCCL.Code.SecureGroupI</IndexLocation>
<StreamLocation>^DHCCL.Code.SecureGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
