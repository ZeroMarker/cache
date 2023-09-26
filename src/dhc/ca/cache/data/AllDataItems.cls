Class dhc.ca.cache.data.AllDataItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AllDataItems_rowid, SqlTableName = AllDataItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AllDataItems_order
Property AllDataItemsorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AllDataItems_order ];

/// AllDataItems_code
Property AllDataItemscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AllDataItems_code ];

/// AllDataItems_name
Property AllDataItemsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AllDataItems_name ];

/// AllDataItems_shortcut
Property AllDataItemsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AllDataItems_shortcut ];

/// AllDataItems_remark
Property AllDataItemsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AllDataItems_remark ];

/// AllDataItems_active
Property AllDataItemsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = AllDataItems_active ];

/// AllDataItems_unit
Property AllDataItemsunit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AllDataItems_unit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAALLDATAITEMS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="AllDataItems_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AllDataItems_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AllDataItems_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AllDataItems_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AllDataItems_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AllDataItems_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AllDataItems_unit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCAALLDATAITEMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAALLDATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AllDataItems_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAALLDATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AllDataItems_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAALLDATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AllDataItems_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCAALLDATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AllDataItems_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAALLDATAITEMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AllDataItems_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AllDataItems_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AllDataItems_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.AllDataItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
