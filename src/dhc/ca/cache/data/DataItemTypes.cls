Class dhc.ca.cache.data.DataItemTypes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataItemTypes_rowid, SqlTableName = DataItemTypes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DataItemTypes_order
Property DataItemTypesorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DataItemTypes_order ];

/// DataItemTypes_code
Property DataItemTypescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DataItemTypes_code ];

/// DataItemTypes_name
Property DataItemTypesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataItemTypes_name ];

/// DataItemTypes_shortcut
Property DataItemTypesshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DataItemTypes_shortcut ];

/// DataItemTypes_remark
Property DataItemTypesremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DataItemTypes_remark ];

/// DataItemTypes_active
Property DataItemTypesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DataItemTypes_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATAITEMTYPES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataItemTypes_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DataItemTypes_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataItemTypes_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataItemTypes_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataItemTypes_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DataItemTypes_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCADATAITEMTYPES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADATAITEMTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemTypes_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADATAITEMTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemTypes_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADATAITEMTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemTypes_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCADATAITEMTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemTypes_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCADATAITEMTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataItemTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataItemTypes_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataItemTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataItemTypesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
