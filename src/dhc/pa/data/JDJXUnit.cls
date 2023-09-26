Class dhc.pa.data.JDJXUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JDJXUnit_rowid, SqlTableName = JDJXUnit ]
{

/// JDUnit_code
Property JDUnitcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JDUnit_code ];

/// JDUnit_name
Property JDUnitname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JDUnit_name ];

/// JDUnit_unitDr
Property JDUnitunitDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JDUnit_unitDr ];

Storage Default
{
<Data name="JDJXUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JDUnitcode</Value>
</Value>
<Value name="3">
<Value>JDUnitname</Value>
</Value>
<Value name="4">
<Value>JDUnitunitDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.JDJXUnitD</DataLocation>
<DefaultData>JDJXUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.JDJXUnitD</IdLocation>
<IndexLocation>^dhc.pa.data.JDJXUnitI</IndexLocation>
<StreamLocation>^dhc.pa.data.JDJXUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
