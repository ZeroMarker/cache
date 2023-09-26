Class dhc.pa.inter.YantaiUnitMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = YantaiUnitMap_rowid, SqlTableName = YantaiUnitMap ]
{

Parameter EXTENTSIZE = 250;

Property YantaiUnitMapInDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = YantaiUnitMap_InDr ];

Property YantaiUnitMapOutDr As dhc.pa.inter.OutKpiRule [ SqlColumnNumber = 3, SqlFieldName = YantaiUnitMap_OutDr ];

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = YantaiUnitMap_Type ];

Index OutUnitDr On YantaiUnitMapOutDr As Exact;

Index TypeOutUnitDr On (Type, YantaiUnitMapOutDr);

Storage Default
{
<Data name="YantaiUnitMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>YantaiUnitMapInDr</Value>
</Value>
<Value name="3">
<Value>YantaiUnitMapOutDr</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.inter.YantaiUnitMapD</DataLocation>
<DefaultData>YantaiUnitMapDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhc.pa.inter.YantaiUnitMapD</IdLocation>
<IndexLocation>^dhc.pa.inter.YantaiUnitMapI</IndexLocation>
<StreamLocation>^dhc.pa.inter.YantaiUnitMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
