Class dhc.sync.data.UP2SMap Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_UP2SMap ]
{

Property UserCode As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0);

Property UserPassword As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0);

Property SystemCode As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0);

Storage Default
{
<Data name="UP2SMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserCode</Value>
</Value>
<Value name="3">
<Value>UserPassword</Value>
</Value>
<Value name="4">
<Value>SystemCode</Value>
</Value>
<Value name="5">
<Value>PrivateKey</Value>
</Value>
<Value name="6">
<Value>PublicKey</Value>
</Value>
</Data>
<DataLocation>^dhcsyncUP2SMapD</DataLocation>
<DefaultData>UP2SMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncUP2SMapD</IdLocation>
<IndexLocation>^dhcsync.UP2SMapI</IndexLocation>
<StreamLocation>^dhcsync.UP2SMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
