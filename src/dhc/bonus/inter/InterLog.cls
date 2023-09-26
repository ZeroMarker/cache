Class dhc.bonus.inter.InterLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterLog_rowid, SqlTableName = InterLog ]
{

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InterLog_Year ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterLog_Period ];

Property InterMethodDr As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 4, SqlFieldName = InterLog_MethodDr ];

Property ImportDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterLog_ImportDate ];

Property status As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InterLog_status ];

Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = InterLog_Flag ];

Property InterLogDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = InterLog_LogDesc ];

Storage Default
{
<Data name="InterLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>InterMethodDr</Value>
</Value>
<Value name="5">
<Value>ImportDate</Value>
</Value>
<Value name="6">
<Value>status</Value>
</Value>
<Value name="7">
<Value>Flag</Value>
</Value>
<Value name="8">
<Value>InterLogDesc</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.inter.InterLogD</DataLocation>
<DefaultData>InterLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsInterLogD</IdLocation>
<IndexLocation>^dhcbsInterLogI</IndexLocation>
<StreamLocation>^dhcbsInterLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
