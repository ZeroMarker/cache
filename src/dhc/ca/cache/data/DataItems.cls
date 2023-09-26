Class dhc.ca.cache.data.DataItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataItems_rowid, SqlTableName = DataItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DataItems_code
Property DataItemscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DataItems_code ];

/// DataItems_name
Property DataItemsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DataItems_name ];

/// DataItems_desc
Property DataItemsdesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataItems_desc ];

/// DataItems_price
Property DataItemsprice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DataItems_price ];

/// DataItems_dataTypeDr
Property DataItemsdataTypeDr As dhc.ca.cache.data.DataTypes [ SqlColumnNumber = 6, SqlFieldName = DataItems_dataTypeDr ];

/// DataItems_active
Property DataItemsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DataItems_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATAITEMS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataItems_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DataItems_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataItems_dataTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DataItems_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataItems_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataItems_price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCADATAITEMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_dataTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeActive">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_dataTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_dataTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDesc">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_dataTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeName">
<Global>^DHCCADATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItems_dataTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItems_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
