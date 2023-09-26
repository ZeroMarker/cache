/// Locs
Class dhc.pa.inter.Locs Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Locs_rowid, SqlTableName = Locs ]
{

/// Locs_code
Property Locscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Locs_code ];

/// Locs_name
Property Locsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Locs_name ];

Storage Default
{
<Data name="LocsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Locscode</Value>
</Value>
<Value name="3">
<Value>Locsname</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.inter.LocsD</DataLocation>
<DefaultData>LocsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.inter.LocsD</IdLocation>
<IndexLocation>^dhc.pa.inter.LocsI</IndexLocation>
<StreamLocation>^dhc.pa.inter.LocsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
