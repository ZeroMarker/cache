/// 同步日志
Class dhc.sync.data.SyncLog Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_SyncLog ]
{

Property Info As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Info ];

Property UserCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UserCode ];

Property SysCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SysCode ];

Property data As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = data ];

Storage Default
{
<Data name="SyncLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Info</Value>
</Value>
<Value name="3">
<Value>data</Value>
</Value>
<Value name="4">
<Value>UserCode</Value>
</Value>
<Value name="5">
<Value>SysCode</Value>
</Value>
</Data>
<DataLocation>^dhc.sync.data.SyncLogD</DataLocation>
<DefaultData>SyncLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.sync.data.SyncLogD</IdLocation>
<IndexLocation>^dhc.sync.data.SyncLogI</IndexLocation>
<StreamLocation>^dhc.sync.data.SyncLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
