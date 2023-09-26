Class dhc.pa.inter.KPIValueInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPIVI_RowID, SqlTableName = KPIValueInfo ]
{

Property KPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KPIVI_KPIDr ];

Property value As %Float [ SqlColumnNumber = 4, SqlFieldName = KPIVI_value ];

Property jxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = KPIVI_JXUnitDr ];

Storage Default
{
<Data name="KPIValueInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIDr</Value>
</Value>
<Value name="3">
<Value>jxUnitDr</Value>
</Value>
<Value name="4">
<Value>value</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAKPIValueInfoD</DataLocation>
<DefaultData>KPIValueInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAKPIValueInfoD</IdLocation>
<IndexLocation>^DHCCJXPAKPIValueInfoI</IndexLocation>
<StreamLocation>^dhc.pa.inter.KPIValueInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
