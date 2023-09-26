Class dhc.sync.data.U2SMap Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_U2SMap ]
{

Property UserCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UserCode ];

Property SystemCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SystemCode ];

Property State As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = State ];

Property Password As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Password ];

Index U2SMapIndex On (UserCode, SystemCode);

Index U2SUcodeIndex On UserCode;

Storage Default
{
<Data name="U2SMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserCode</Value>
</Value>
<Value name="3">
<Value>SystemCode</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
<Value name="5">
<Value>Password</Value>
</Value>
</Data>
<DataLocation>^dhcsyncU2SMapD</DataLocation>
<DefaultData>U2SMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncU2SMapD</IdLocation>
<IndexLocation>^dhcsyncU2SMapI</IndexLocation>
<StreamLocation>^dhcsyncU2SMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
