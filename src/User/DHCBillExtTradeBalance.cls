Class User.DHCBillExtTradeBalance Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ETB_RowID, SqlTableName = DHC_BillExtTradeBalance, StorageStrategy = SQLStorage ]
{

/// ETB_TradeDate 交易日期
Property ETBTradeDate As %Library.Date [ SqlColumnNumber = 2, SqlFieldName = ETB_TradeDate ];

/// ETB_TradeTime 交易时间
Property ETBTradeTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = ETB_TradeTime ];

/// ETB_TradeAmt 交易金额
Property ETBTradeAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ETB_TradeAmt ];

/// ETB_TradeFlag	正反交易标志
Property ETBTradeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ETB_TradeFlag ];

/// ETB_TradeNo	交易唯一流水
Property ETBTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ETB_TradeNo ];

/// ETB_TradeUser	交易人
Property ETBTradeUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ETB_TradeUser ];

/// ETB_Terminal	交易终端
Property ETBTerminal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ETB_Terminal ];

/// ETB_Merch	交易商户
Property ETBMerch As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ETB_Merch ];

/// ETB_PayCardNo	交易卡号/支付卡号
Property ETBPayCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ETB_PayCardNo ];

/// ETB_CardType	交易卡类型
Property ETBCardType As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ETB_CardType ];

/// ETB_HISTradeNo	HIS交易流水号
Property ETBHISTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ETB_HISTradeNo ];

/// ETB_OutTradeNo	第三方交易流水
Property ETBOutTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ETB_OutTradeNo ];

/// ETB_OldTradeNo	原交易唯一流水
Property ETBOldTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ETB_OldTradeNo ];

/// ETB_PaymodeDr	支付方式
Property ETBPaymodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ETB_PaymodeDr ];

/// ETB_Channel	交易渠道
Property ETBChannel As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ETB_Channel ];

/// ETB_FinDate	对账日期
Property ETBFinDate As %Library.Date [ SqlColumnNumber = 17, SqlFieldName = ETB_FinDate ];

/// ETP_PatientID	患者ID
Property ETPPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ETP_PatientID ];

/// ETB_ExtString	单条全部对账信息
Property ETBExtString As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ETB_ExtString ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCBILLETB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ETB_CardType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ETB_Channel">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ETB_ExtString">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ETB_FinDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ETB_HISTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ETB_Merch">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ETB_OldTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ETB_OutTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ETB_PayCardNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ETB_PaymodeDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ETB_Terminal">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ETB_TradeAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ETB_TradeDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ETB_TradeFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ETB_TradeNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ETB_TradeTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ETB_TradeUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ETP_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCBILLETB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChannel">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Channel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_Channel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinDate">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FinDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_FinDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISTradeNo">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISTradeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_HISTradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldTradeNo">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OldTradeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_OldTradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutTradeNo">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutTradeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_OutTradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayMTNo">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PayMTNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_PaymodeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_TradeNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTDatePayM">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TDatePayM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_PaymodeDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeDate">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_TradeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTradeNo">
<Global>^DHCBILLETBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ETB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETB_TradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ETB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHC_BillExtTradeBalance</SqlRowIdName>
<StreamLocation>^User.DHCBillExtTradeBalanceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
