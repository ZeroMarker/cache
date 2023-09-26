Class dhc.pa.data.UnitKPIMapDirectInput Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitKPIMapDirectInput_rowid, SqlTableName = UnitKPIMapDirectInput ]
{

Property UnitKPIMapDirectInputUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = UnitKPIMapDirectInput_UnitDr ];

Property UnitKPIMapDirectInputKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 3, SqlFieldName = UnitKPIMapDirectInput_KPIDr ];

Storage Default
{
<Data name="UnitKPIMapDirectInputDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnitKPIMapDirectInputKPIDr</Value>
</Value>
<Value name="3">
<Value>UnitKPIMapDirectInputUnitDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.UnitKPIMapDi80DD</DataLocation>
<DefaultData>UnitKPIMapDirectInputDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.UnitKPIMapDi80DD</IdLocation>
<IndexLocation>^dhc.pa.data.UnitKPIMapDi80DI</IndexLocation>
<StreamLocation>^dhc.pa.data.UnitKPIMapDi80DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
