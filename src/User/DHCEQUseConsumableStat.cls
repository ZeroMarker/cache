Class User.DHCEQUseConsumableStat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UCS_RowID, SqlTableName = DHC_EQUseConsumableStat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UCS_Amount
Property UCSAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UCS_Amount ];

/// UCS_ConsumableItemDR
Property UCSConsumableItemDR As User.DHCEQCConsumableItem [ SqlColumnNumber = 3, SqlFieldName = UCS_ConsumableItemDR ];

/// UCS_Hold1
Property UCSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UCS_Hold1 ];

/// UCS_Hold2
Property UCSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UCS_Hold2 ];

/// UCS_Hold3
Property UCSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = UCS_Hold3 ];

/// UCS_Hold4
Property UCSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = UCS_Hold4 ];

/// UCS_Hold5
Property UCSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = UCS_Hold5 ];

/// UCS_Price
Property UCSPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = UCS_Price ];

/// UCS_Quantity
Property UCSQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = UCS_Quantity ];

/// UCS_Remark
Property UCSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UCS_Remark ];

/// UCS_ServDetItemDR
Property UCSServDetItemDR As User.DHCEQCServDetItem [ SqlColumnNumber = 9, SqlFieldName = UCS_ServDetItemDR ];

/// UCS_ServiceItemDR
Property UCSServiceItemDR As User.DHCEQCServiceItem [ SqlColumnNumber = 8, SqlFieldName = UCS_ServiceItemDR ];

/// UCS_UOMDR
Property UCSUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UCS_UOMDR ];

/// UCS_UseRecordStatDR
Property UCSUseRecordStatDR As User.DHCEQUseRecordStat [ SqlColumnNumber = 2, SqlFieldName = UCS_UseRecordStatDR ];

/// UCS_PayPrice
Property UCSPayPrice As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = UCS_PayPrice ];

/// UCS_PayAmount
Property UCSPayAmount As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = UCS_PayAmount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseConsumableStat("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UCS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UCS_ConsumableItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UCS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UCS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UCS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UCS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UCS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UCS_PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UCS_PayPrice">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UCS_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UCS_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UCS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UCS_ServDetItemDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UCS_ServiceItemDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UCS_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UCS_UseRecordStatDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUseConsumableStat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UCS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConsumableItem">
<Global>^DHCEQUseConsumableStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ConsumableItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCS_ConsumableItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseRecordStat">
<Global>^DHCEQUseConsumableStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseRecordstat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCS_UseRecordStatDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseConsumableStatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
