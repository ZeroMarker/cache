/// 诊断状态
Class DHCCL.Code.DiagosStatus Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DiagnosStatus ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="DiagosStatusDefaultData">
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
<DataLocation>^DHCCL.Code.DiagnosStatusD</DataLocation>
<DefaultData>DiagosStatusDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.DiagnosStatusD</IdLocation>
<IndexLocation>^DHCCL.Code.DiagnosStatusI</IndexLocation>
<StreamLocation>^DHCCL.Code.DiagnosStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
