Class dhc.pa.data.JXBaseDataTemporary Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ID ]
{

Property DeptDr As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ Required, SqlColumnNumber = 2 ];

Property period As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property periodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property KPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 5 ];

Property actualValue As %Library.Float [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="JXBaseDataTemporaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptDr</Value>
</Value>
<Value name="3">
<Value>period</Value>
</Value>
<Value name="4">
<Value>periodType</Value>
</Value>
<Value name="5">
<Value>KPIDr</Value>
</Value>
<Value name="6">
<Value>actualValue</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPATemporaryD</DataLocation>
<DefaultData>JXBaseDataTemporaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPATemporaryD</IdLocation>
<IndexLocation>^DHCCJXPATemporaryI</IndexLocation>
<StreamLocation>^DHCCJXPATemporaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
