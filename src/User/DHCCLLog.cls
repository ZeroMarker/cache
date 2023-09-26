Class User.DHCCLLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CLLOG_RowId, SqlTableName = DHC_CL_Log, StorageStrategy = CacheStorage ]
{

Property CLLOGCLCLOGDr As DHCCLCLog [ SqlColumnNumber = 2, SqlFieldName = CLLOG_CLCLOG_Dr ];

Property CLLOGLogRecordDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLLOG_LogRecord_Dr ];

Property CLLOGPreValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CLLOG_PreValue ];

Property CLLOGPreNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CLLOG_PreNote ];

Property CLLOGPostValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CLLOG_PostValue ];

Property CLLOGPostNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CLLOG_PostNote ];

Property CLLOGUpdateUserDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CLLOG_UpdateUser_Dr ];

Property CLLOGUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CLLOG_UpdateDate ];

Property CLLOGUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CLLOG_UpdateTime ];

Property CLLOGUpdateTcpip As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CLLOG_UpdateTcpip ];

Property CLLOGIfReceive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = CLLOG_IfReceive ];

Index ClclogDate On (CLLOGCLCLOGDr As Exact, CLLOGUpdateDate As Exact, CLLOGLogRecordDr As Exact);

Storage CacheStorage
{
<Data name="DHCCLLogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DHCCLLogDefaultData">
<Value name="1">
<Value>CLLOGCLCLOGDr</Value>
</Value>
<Value name="2">
<Value>CLLOGLogRecordDr</Value>
</Value>
<Value name="3">
<Value>CLLOGPreValue</Value>
</Value>
<Value name="4">
<Value>CLLOGPreNote</Value>
</Value>
<Value name="5">
<Value>CLLOGPostValue</Value>
</Value>
<Value name="6">
<Value>CLLOGPostNote</Value>
</Value>
<Value name="7">
<Value>CLLOGUpdateUserDr</Value>
</Value>
<Value name="8">
<Value>CLLOGUpdateDate</Value>
</Value>
<Value name="9">
<Value>CLLOGUpdateTime</Value>
</Value>
<Value name="10">
<Value>CLLOGUpdateTcpip</Value>
</Value>
<Value name="11">
<Value>CLLOGIfReceive</Value>
</Value>
</Data>
<DataLocation>^DHCCLLogD</DataLocation>
<DefaultData>DHCCLLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLLogD</IdLocation>
<IndexLocation>^DHCCLLogI</IndexLocation>
<StreamLocation>^User.DHCCLLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
