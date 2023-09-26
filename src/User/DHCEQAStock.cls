Class User.DHCEQAStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AS_RowID, SqlTableName = DHC_EQAStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AS_LocDR
Property ASLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AS_LocDR ];

/// AS_ItemDR
Property ASItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = AS_ItemDR ];

/// AS_Code
Property ASCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AS_Code ];

/// AS_Desc
Property ASDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AS_Desc ];

/// AS_AccessoryTypeDR
Property ASAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 6, SqlFieldName = AS_AccessoryTypeDR ];

/// AS_ExpiryDate
Property ASExpiryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = AS_ExpiryDate ];

/// AS_FinalBPrice
Property ASFinalBPrice As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AS_FinalBPrice ];

/// AS_WtdBPrice
Property ASWtdBPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AS_WtdBPrice ];

/// AS_Amount
Property ASAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AS_Amount ];

/// AS_Stock
Property ASStock As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AS_Stock ];

/// AS_FreezeStock
Property ASFreezeStock As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AS_FreezeStock ];

/// AS_Hold1
Property ASHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AS_Hold1 ];

/// AS_Hold2
Property ASHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AS_Hold2 ];

/// AS_Hold3
Property ASHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AS_Hold3 ];

/// AS_Hold4
Property ASHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AS_Hold4 ];

/// AS_Hold5
Property ASHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AS_Hold5 ];

/// AS_Hold6
Property ASHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AS_Hold6 ];

/// AS_Hold7
Property ASHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AS_Hold7 ];

/// AS_Hold8
Property ASHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AS_Hold8 ];

/// AS_Hold9
Property ASHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AS_Hold9 ];

/// AS_Hold10
Property ASHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AS_Hold10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AS_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AS_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AS_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AS_FinalBPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AS_FreezeStock">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AS_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AS_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AS_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AS_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AS_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AS_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AS_Stock">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AS_WtdBPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQAStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccessory">
<Global>^DHCEQAStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Accessory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AS_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQAStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AS_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocType">
<Global>^DHCEQAStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AS_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
