Class User.DHCEQARealStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ARS_RowID, SqlTableName = DHC_EQARealStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ARS_LocDR
Property ARSLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ARS_LocDR ];

/// ARS_ItemDR
Property ARSItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = ARS_ItemDR ];

/// ARS_Price
Property ARSPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ARS_Price ];

/// ARS_StockBegin
Property ARSStockBegin As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ARS_StockBegin ];

/// ARS_StockEnd
Property ARSStockEnd As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ARS_StockEnd ];

/// ASR_AduitDate
Property ASRAduitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ASR_AduitDate ];

/// ARS_Hold1
Property ARSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ARS_Hold1 ];

/// ARS_Hold2
Property ARSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ARS_Hold2 ];

/// ARS_Hold3
Property ARSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ARS_Hold3 ];

/// ARS_Hold4
Property ARSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ARS_Hold4 ];

/// ARS_Hold5
Property ARSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ARS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQARealStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARS_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARS_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARS_StockBegin">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARS_StockEnd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASR_AduitDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQARealStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAduitDate">
<Global>^DHCEQARealStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AduitDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_AduitDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQARealStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARS_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQARealStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
