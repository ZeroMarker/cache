Class dhc.pa.inter.PAScoreLogger Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PSL_RowID, SqlTableName = PAScoreLogger ]
{

Property updateDate As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PSL_updateDate ];

Property updateUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PSL_updateUser ];

Property updateField As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PSL_updateField ];

Property updateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PSL_updateDesc ];

Storage Default
{
<Data name="PAScoreLoggerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>updateDate</Value>
</Value>
<Value name="3">
<Value>updateUser</Value>
</Value>
<Value name="4">
<Value>updateField</Value>
</Value>
<Value name="5">
<Value>updateDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAPAScoreLoggerD</DataLocation>
<DefaultData>PAScoreLoggerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAPAScoreLoggerD</IdLocation>
<IndexLocation>^DHCCJXPAPAScoreLoggerI</IndexLocation>
<StreamLocation>^dhc.pa.inter.PAScoreLoggerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
