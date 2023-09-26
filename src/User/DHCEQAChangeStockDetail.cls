Class User.DHCEQAChangeStockDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACSD_RowID, SqlTableName = DHC_EQAChangeStockDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ACSD_ChangeStockDR
Property ACSDChangeStockDR As User.DHCEQAChangeStock [ SqlColumnNumber = 2, SqlFieldName = ACSD_ChangeStockDR ];

/// ACSD_StockDetailDR
Property ACSDStockDetailDR As User.DHCEQAStockDetail [ SqlColumnNumber = 3, SqlFieldName = ACSD_StockDetailDR ];

/// ACSD_ToStockDetailDR
Property ACSDToStockDetailDR As User.DHCEQAStockDetail [ SqlColumnNumber = 4, SqlFieldName = ACSD_ToStockDetailDR ];

/// ACSD_BaseStock
Property ACSDBaseStock As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ACSD_BaseStock ];

/// ACSD_Stock
Property ACSDStock As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ACSD_Stock ];

/// ACSD_Hold1
Property ACSDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ACSD_Hold1 ];

/// ACSD_Hold2
Property ACSDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ACSD_Hold2 ];

/// ACSD_Hold3
Property ACSDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ACSD_Hold3 ];

/// ACSD_Hold4
Property ACSDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ACSD_Hold4 ];

/// ACSD_Hold5
Property ACSDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ACSD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAChangeStockDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACSD_BaseStock">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACSD_ChangeStockDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACSD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACSD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACSD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACSD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ACSD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ACSD_Stock">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACSD_StockDetailDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACSD_ToStockDetailDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQAChangeStockDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ACSD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChangeStock">
<Global>^DHCEQAChangeStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChangeStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACSD_ChangeStockDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStockDetail">
<Global>^DHCEQAChangeStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StockDetail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACSD_StockDetailDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAChangeStockDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
