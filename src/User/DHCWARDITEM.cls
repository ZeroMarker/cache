Class User.DHCWARDITEM Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ITEM_ROWID, SqlTableName = DHC_WARDITEM, StorageStrategy = SqlStorage ]
{

/// ITEM_CODE
Property ITEMCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ITEM_CODE ];

/// ITEM_DESC
Property ITEMDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ITEM_DESC ];

/// ITEM_ORDER
Property ITEMORDER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ITEM_ORDER ];

/// ITEM_VISIBLE
Property ITEMVISIBLE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ITEM_VISIBLE ];

/// ITEM_METHOD
Property ITEMMETHOD As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ITEM_METHOD ];

/// ITEM_WARDID
Property ITEMWARDID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ITEM_WARDID ];

/// ITEM_CATEGORY
Property ITEMCATEGORY As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ITEM_CATEGORY ];

Storage SqlStorage
{
<SqlIdExpression>$i(^NURWARDITEM("nurward"))</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="ITEM_CATEGORY">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITEM_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITEM_DESC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITEM_METHOD">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITEM_ORDER">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITEM_VISIBLE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITEM_WARDID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^NURWARDITEM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ITEM_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"nurward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ITEM_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDHCWARDID">
<Global>^NURWARDITEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L3</Expression>
<Field>ITEM_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WARDID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ITEM_WARDID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITEM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDHCWARDITEM">
<Global>^NURWARDITEM</Global>
<RowIdSpec name="1">
<Expression>L3</Expression>
<Field>ITEM_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ITEMDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ITEM_DESC}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITEM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWARDITEMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
