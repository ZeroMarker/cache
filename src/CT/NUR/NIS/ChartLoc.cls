/// 体温单等样式表适用科室
Class CT.NUR.NIS.ChartLoc Extends %Persistent [ SqlTableName = ChartLoc, StorageStrategy = CacheStorage ]
{

// Index RowIDBasedIDKeyIndex On LocChildsub [ IdKey, PrimaryKey, Unique ];

/// Chart Parent Reference
Relationship LocParRef As Chart [ Cardinality = parent, Inverse = ChildChartLoc, Required, SqlFieldName = ParRef ];

// Property LocChildsub As %Integer [ InitialExpression = {$i(^CT.NUR.NIS.Chart($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = Childsub ];

/// Childsub
/// LocID
Property LocID As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = LocID ];

/// Type 
Property Type As %String(DISPLAYLIST = ",适用,不适用", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Type ];

Index LOCState On (Type, LocID, LocParRef);

Storage CacheStorage
{
<Data name="ChartLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocID</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartLoc")</DataLocation>
<DefaultData>ChartLocDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartLoc")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartLocI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
