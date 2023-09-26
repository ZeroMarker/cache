Class dhc.qm.data.Cycle Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Cycle_rowid, SqlTableName = Cycle ]
{

/// Cycle_code
Property Cyclecode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Cycle_code ];

/// Cycle_name
Property Cyclename As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Cycle_name ];

/// Cycle_active
Property Cycleactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Cycle_active ];

Index IndexSysName On Cyclename;

Index IndexSysCode On Cyclecode;

Storage Default
{
<Data name="CycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Cyclecode</Value>
</Value>
<Value name="3">
<Value>Cyclename</Value>
</Value>
<Value name="4">
<Value>Cycleactive</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMCycleD</DataLocation>
<DefaultData>CycleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMCycleD</IdLocation>
<IndexLocation>^DHCCJXQMCycleI</IndexLocation>
<StreamLocation>^DHCCJXQMCycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
