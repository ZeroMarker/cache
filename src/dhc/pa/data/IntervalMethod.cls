Class dhc.pa.data.IntervalMethod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IntervalMethod_rowid, SqlTableName = IntervalMethod, StorageStrategy = Default ]
{

Parameter EXTENTSIZE = 250;

Property IntervalMethodKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = IntervalMethod_KPIDr ];

Property IntervalMethodEqual As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = IntervalMethod_Equal ];

Property IntervalMethodKey As %Float [ SqlColumnNumber = 4, SqlFieldName = IntervalMethod_Key ];

Property IntervalMethodValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IntervalMethod_Value ];

Storage Default
{
<Data name="IntervalMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntervalMethodEqual</Value>
</Value>
<Value name="3">
<Value>IntervalMethodKey</Value>
</Value>
<Value name="4">
<Value>IntervalMethodValue</Value>
</Value>
<Value name="5">
<Value>IntervalMethodKPIDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.IntervalMethodD</DataLocation>
<DefaultData>IntervalMethodDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhc.pa.data.IntervalMethodD</IdLocation>
<IndexLocation>^dhc.pa.data.IntervalMethodI</IndexLocation>
<StreamLocation>^dhc.pa.data.IntervalMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
