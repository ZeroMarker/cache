/// Type
Class dhc.pa.inter.Type Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Type_rowid, SqlTableName = Type ]
{

/// Type_code
Property Typecode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Type_code ];

/// Type_name
Property Typename As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Type_name ];

Storage Default
{
<Data name="TypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Typecode</Value>
</Value>
<Value name="3">
<Value>Typename</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.inter.TypeD</DataLocation>
<DefaultData>TypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.inter.TypeD</IdLocation>
<IndexLocation>^dhc.pa.inter.TypeI</IndexLocation>
<StreamLocation>^dhc.pa.inter.TypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
