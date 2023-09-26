Class dhc.ca.cache.data.LocLevelLast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocLevelLast_rowid, SqlTableName = LocLevelLast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LocLevelLastchildSub [ IdKey, PrimaryKey, Unique ];

/// LocLevel Parent Reference
Relationship LocLevelLastparRef As dhc.ca.cache.data.LocLevel [ Cardinality = parent, Inverse = ChildLocLevelLast, Required, SqlFieldName = LocLevelLast_parRef ];

/// LocLevelLast_childSub
Property LocLevelLastchildSub As %Library.Float [ InitialExpression = {$i(^DHCCALOCLEVEL($p(%d(0),$c(1),1),"Locs",0))}, SqlColumnNumber = 2, SqlFieldName = LocLevelLast_childSub ];

/// LocLevelLast_locDr
Property LocLevelLastlocDr As dhc.ca.cache.data.Locs [ SqlColumnNumber = 3, SqlFieldName = LocLevelLast_locDr ];

/// LocLevelLast_recCost
Property LocLevelLastrecCost As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LocLevelLast_recCost ];

/// LocLevelLast_order
Property LocLevelLastorder As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = LocLevelLast_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="LocLevelLast_locDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LocLevelLast_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LocLevelLast_recCost">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCALOCLEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LocLevel.LocLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LocLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LocLevel.LocLevel_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Locs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevelLast_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>LocLevel.LocLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LocLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel.LocLevel_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevelLast_locDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LocLevelLast_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOrder">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>LocLevel.LocLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LocLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel.LocLevel_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevelLast_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LocLevelLast_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LocLevelLastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
