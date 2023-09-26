Class dhc.bonus.data.BonusLogRecord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusLogRecordID, SqlTableName = BonusLogRecord ]
{

Property OptionUserID As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = OptionUserID ];

Property OptionName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OptionName ];

Property OptionDate As %Library.TimeStamp [ SqlColumnNumber = 4, SqlFieldName = OptionDate ];

Storage Default
{
<Data name="BonusLogRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OptionName</Value>
</Value>
<Value name="3">
<Value>OptionUser</Value>
</Value>
<Value name="4">
<Value>OptionDate</Value>
</Value>
<Value name="5">
<Value>OptionUserID</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.data.BonusLogRecordD</DataLocation>
<DefaultData>BonusLogRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus.data.BonusLogRecordD</IdLocation>
<IndexLocation>^dhc.bonus.data.BonusLogRecordI</IndexLocation>
<StreamLocation>^dhc.bonus.data.BonusLogRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
