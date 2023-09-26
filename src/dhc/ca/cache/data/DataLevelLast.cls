Class dhc.ca.cache.data.DataLevelLast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataLevelLast_rowid, SqlTableName = DataLevelLast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DataLevelLastchildSub [ IdKey, PrimaryKey, Unique ];

/// DataLevel Parent Reference
Relationship DataLevelLastparRef As dhc.ca.cache.data.DataLevel [ Cardinality = parent, Inverse = ChildDataLevelLast, Required, SqlFieldName = DataLevelLast_parRef ];

/// DataLevelLast_childSub
Property DataLevelLastchildSub As %Library.Float [ InitialExpression = {$i(^DHCCADATALEVEL($p(%d(0),$c(1),1),"ITEM",0))}, SqlColumnNumber = 2, SqlFieldName = DataLevelLast_childSub ];

/// DataLevelLast_dataItemDr
Property DataLevelLastdataItemDr As dhc.ca.cache.data.DataItems [ SqlColumnNumber = 3, SqlFieldName = DataLevelLast_dataItemDr ];

/// DataLevelLast_order
Property DataLevelLastorder As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DataLevelLast_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DataLevelLast_dataItemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataLevelLast_order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCADATALEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataLevel.DataLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DataLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataLevel.DataLevel_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelLast_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDataItem">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DataLevel.DataLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DataLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DataItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel.DataLevel_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelLast_dataItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataLevelLast_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDataItemOrder">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DataLevel.DataLevel_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DataLevelLast_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DataItemOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel.DataLevel_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelLast_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataLevelLast_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataLevelLastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
