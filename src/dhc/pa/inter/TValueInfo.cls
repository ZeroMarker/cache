Class dhc.pa.inter.TValueInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TValue_RowID, SqlTableName = TValueInfo ]
{

Property KPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = TValue_KPIDr ];

Property value As %Float [ SqlColumnNumber = 4, SqlFieldName = TValue_value ];

Property jxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = TValue_JXUnitDr ];

Storage Default
{
<Data name="TValueInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIDr</Value>
</Value>
<Value name="3">
<Value>value</Value>
</Value>
<Value name="4">
<Value>jxUnitDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPATValueInfoD</DataLocation>
<DefaultData>TValueInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPATValueInfoD</IdLocation>
<IndexLocation>^DHCCJXPATValueInfoI</IndexLocation>
<StreamLocation>^dhc.pa.inter.TValueInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
