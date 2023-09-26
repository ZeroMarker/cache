Class dhc.ca.cache.data.DataItemCorres Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataItemCorres_rowid, SqlTableName = DataItemCorres, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DataItemCorres_typeDr
Property DataItemCorrestypeDr As dhc.ca.cache.data.DataItemTypes [ SqlColumnNumber = 2, SqlFieldName = DataItemCorres_typeDr ];

/// DataItemCorres_order
Property DataItemCorresorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DataItemCorres_order ];

/// DataItemCorres_itemDr
Property DataItemCorresitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = DataItemCorres_itemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATAITEMCORRES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataItemCorres_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataItemCorres_order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataItemCorres_typeDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCADATAITEMCORRES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataItemCorres_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataItemCorres_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeItem">
<Global>^DHCCADATAITEMCORRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItemCorres_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemCorres_typeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemCorres_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItemCorres_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeOrder">
<Global>^DHCCADATAITEMCORRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItemCorres_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemCorres_typeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemCorres_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItemCorres_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataItemCorresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
