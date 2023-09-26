Class User.DHCEQStoreMonthStatList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMSL_RowID, SqlTableName = DHC_EQStoreMonthStatList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SMSL_StoreMonthStatDR
Property SMSLStoreMonthStatDR As User.DHCEQStoreMonthStat [ SqlColumnNumber = 2, SqlFieldName = SMSL_StoreMonthStatDR ];

/// SMSL_StatCatDR
Property SMSLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 3, SqlFieldName = SMSL_StatCatDR ];

/// SMSL_StockOpenNum
Property SMSLStockOpenNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SMSL_StockOpenNum ];

/// SMSL_StockInNum
Property SMSLStockInNum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMSL_StockInNum ];

/// SMSL_StockOutNum
Property SMSLStockOutNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMSL_StockOutNum ];

/// SMSL_StockReturnNum
Property SMSLStockReturnNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMSL_StockReturnNum ];

/// SMSL_StockRefundNum
Property SMSLStockRefundNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMSL_StockRefundNum ];

/// SMSL_StockEndNum
Property SMSLStockEndNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMSL_StockEndNum ];

/// SMSL_UsedOpenNum
Property SMSLUsedOpenNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMSL_UsedOpenNum ];

/// SMSL_UsedConsumNum
Property SMSLUsedConsumNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMSL_UsedConsumNum ];

/// SMSL_UsedLossNum
Property SMSLUsedLossNum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMSL_UsedLossNum ];

/// SMSL_UsedRefundNum
Property SMSLUsedRefundNum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SMSL_UsedRefundNum ];

/// SMSL_UsedEndNum
Property SMSLUsedEndNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SMSL_UsedEndNum ];

/// SMSL_Hold1
Property SMSLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SMSL_Hold1 ];

/// SMSL_Hold2
Property SMSLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SMSL_Hold2 ];

/// SMSL_Hold3
Property SMSLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SMSL_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStoreMonthStatList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMSL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMSL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMSL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMSL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMSL_StockEndNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMSL_StockInNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMSL_StockOpenNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMSL_StockOutNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMSL_StockRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMSL_StockReturnNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMSL_StoreMonthStatDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMSL_UsedConsumNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMSL_UsedEndNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMSL_UsedLossNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMSL_UsedOpenNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMSL_UsedRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQStoreMonthStatList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SMSL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStoreMonth">
<Global>^DHCEQStoreMonthStatList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreMonth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMSL_StoreMonthStatDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreMonthStatCat">
<Global>^DHCEQStoreMonthStatList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreMonthStatCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMSL_StoreMonthStatDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMSL_StatCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStoreMonthStatListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
