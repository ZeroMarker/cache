Class dhc.sync.data.L2SMap Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_L2SMap ]
{

// LocCode SystemCode State

Property LocCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LocCode ];

Property SystemCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SystemCode ];

Property State As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = State ];

Index L2SystemCodeIndex On SystemCode;

Index L2SMapIndex On (LocCode, SystemCode);

Index L2ScodeIndex On LocCode;

Storage Default
{
<Data name="L2SMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocCode</Value>
</Value>
<Value name="3">
<Value>SystemCode</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
</Data>
<DataLocation>^dhcsyncL2SMapD</DataLocation>
<DefaultData>L2SMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncL2SMapD</IdLocation>
<IndexLocation>^dhcsyncL2SMapI</IndexLocation>
<StreamLocation>^dhcsyncL2SMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
