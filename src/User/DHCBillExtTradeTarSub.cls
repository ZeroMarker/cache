Class User.DHCBillExtTradeTarSub Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ETT_RowID, SqlTableName = DHC_BillExtTradeTarSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ETTSub [ IdKey, PrimaryKey, Unique ];

/// DHCBillExtTradePay Parent Reference
Relationship ETTETPParRef As User.DHCBillExtTradePay [ Cardinality = parent, Inverse = ChildDHCBillExtTradeTarSub, Required, SqlFieldName = ETT_ETP_ParRef ];

/// ETT_Sub
Property ETTSub As %Library.Float [ InitialExpression = {$i(^DHCBILLETP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"T",0))}, SqlColumnNumber = 2, SqlFieldName = ETT_Sub ];

/// ETT_TARI_DR
Property ETTTARIDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = ETT_TARI_DR ];

/// Tariff Item Unit Price
Property ETTUnitPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ETT_UnitPrice ];

/// Bill Tariff Item Qty
Property ETTBillQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ETT_BillQty ];

/// Discount Rate
Property ETTDiscPerc As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ETT_DiscPerc ];

/// Tariff Item Total
Property ETTTotalAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ETT_TotalAmount ];

/// Discount Amount
Property ETTDiscAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ETT_DiscAmount ];

/// Insurance Share
Property ETTPayorShare As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ETT_PayorShare ];

/// ETT_PatientShare
Property ETTPatientShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ETT_PatientShare ];

/// Bill Date
Property ETTBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = ETT_BillDate ];

/// ETT_BillTime
Property ETTBillTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = ETT_BillTime ];

/// ETT_BillStatus
Property ETTBillStatus As %Library.String(DISPLAYLIST = ",Billed,Paid,Refund,RefundPaid", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",B,P,R,RP") [ SqlColumnNumber = 13, SqlFieldName = ETT_BillStatus ];

/// ETT_CreateDate
Property ETTCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = ETT_CreateDate ];

/// ETT_CreateTime
Property ETTCreateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = ETT_CreateTime ];

/// ETT_BillUser
Property ETTBillUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = ETT_BillUser ];

/// ETT_ExecDept_Dr
Property ETTExecDeptDr As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = ETT_ExecDept_Dr ];

/// ETT_DiscPrice
Property ETTDiscPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = ETT_DiscPrice ];

/// ETT_InsPrice
Property ETTInsPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = ETT_InsPrice ];

/// ETT_PatPrice
Property ETTPatPrice As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = ETT_PatPrice ];

/// ETT_TradeOrd_Dr
Property ETTTradeOrdDr As User.DHCBillExtTradeOrdSub [ SqlColumnNumber = 21, SqlFieldName = ETT_TradeOrd_Dr ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ETT_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ETT_BillQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ETT_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ETT_BillTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ETT_BillUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ETT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ETT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ETT_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ETT_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ETT_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ETT_ETP_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ETT_ExecDept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ETT_InsPrice">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ETT_PatPrice">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ETT_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ETT_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ETT_Sub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ETT_TARI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ETT_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ETT_TradeOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ETT_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCBILLETP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ETT_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"T"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETT_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTradeOrd">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ETT_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeSub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETT_TradeOrd_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"T"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ETT_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillExtTradeTarSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
