Class dhc.ca.cache.data.DistParams Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DistParams_rowid, SqlTableName = DistParams, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DistParamschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship DistParamsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildDistParams, Required, SqlFieldName = DistParams_parRef ];

/// DistParams_childSub
Property DistParamschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"DistParams",0))}, SqlColumnNumber = 2, SqlFieldName = DistParams_childSub ];

/// DistParams_paramType
Property DistParamsparamType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DistParams_paramType ];

/// DistParams_itemDr
Property DistParamsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = DistParams_itemDr ];

/// DistParams_right
Property DistParamsright As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DistParams_right ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DistParams_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DistParams_paramType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DistParams_right">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CostDistMethods.CostDistMethods_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DistParams_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistMethods.CostDistMethods_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DistParams"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DistParams_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DistParamsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
