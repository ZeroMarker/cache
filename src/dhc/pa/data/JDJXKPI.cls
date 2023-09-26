Class dhc.pa.data.JDJXKPI Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JDJXKPI_rowid, SqlTableName = JDJXKPI ]
{

/// JDJXKPI_code
Property JDJXKPIcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JDJXKPI_code ];

/// JDJXKPI_name
Property JDJXKPIname As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JDJXKPI_name ];

/// JDJXKPI_indexDr
Property JDJXKPIindexDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JDJXKPI_indexDr ];

Storage Default
{
<Data name="JDJXKPIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JDJXKPIcode</Value>
</Value>
<Value name="3">
<Value>JDJXKPIindexDr</Value>
</Value>
<Value name="4">
<Value>JDJXKPIname</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.JDJXKPID</DataLocation>
<DefaultData>JDJXKPIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.JDJXKPID</IdLocation>
<IndexLocation>^dhc.pa.data.JDJXKPII</IndexLocation>
<StreamLocation>^dhc.pa.data.JDJXKPIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
