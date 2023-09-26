Class dhc.pa.data.JDJXPeriod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JDJXPeriod_rowid, SqlTableName = JDJXPeriod ]
{

/// JDJXPeriod_StartDate
Property JDJXPeriodStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = JDJXPeriod_StartDate ];

/// JDJXPeriod_EndDate
Property JDJXPeriodEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = JDJXPeriod_EndDate ];

/// JDJXPeriod_code
Property JDJXPeriodcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JDJXPeriod_code ];

/// JDJXPeriod_name
Property JDJXPeriodname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JDJXPeriod_name ];

/// JDJXPeriod_Frequency
Property JDJXPeriodFrequency As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JDJXPeriod_Frequency ];

Storage Default
{
<Data name="JDJXPeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JDJXPeriodEndDate</Value>
</Value>
<Value name="3">
<Value>JDJXPeriodStartDate</Value>
</Value>
<Value name="4">
<Value>JDJXPeriodcode</Value>
</Value>
<Value name="5">
<Value>JDJXPeriodname</Value>
</Value>
<Value name="6">
<Value>JDJXPeriodFrequency</Value>
</Value>
<Value name="7">
<Value>JDJXPeriodStr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.JDJXPeriodD</DataLocation>
<DefaultData>JDJXPeriodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.JDJXPeriodD</IdLocation>
<IndexLocation>^dhc.pa.data.JDJXPeriodI</IndexLocation>
<StreamLocation>^dhc.pa.data.JDJXPeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
