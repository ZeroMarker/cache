Class User.DHCINVBankBillDetails Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBB_RowID, SqlTableName = DHC_INVBankBillDetails, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IBBSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IBBIBPParRef As User.DHCINVBankTradePay [ Cardinality = parent, Inverse = ChildDHCINVBankBillDetails, Required, SqlFieldName = IBB_IBP_ParRef ];

/// IBB_Sub
Property IBBSub As %Library.Float [ InitialExpression = {$i(^DHCINVBTP($p(%d(0),$c(1)),"BD",0))}, SqlColumnNumber = 2, SqlFieldName = IBB_Sub ];

/// IBB_TARI_DR
Property IBBTARIDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = IBB_TARI_DR ];

/// Tariff Item Unit Price
Property IBBUnitPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IBB_UnitPrice ];

/// Bill Tariff Item Qty
Property IBBBillQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IBB_BillQty ];

/// Discount Rate
Property IBBDiscPerc As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IBB_DiscPerc ];

/// Tariff Item Total
Property IBBTotalAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IBB_TotalAmount ];

/// Discount Amount
Property IBBDiscAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IBB_DiscAmount ];

/// Insurance Share
Property IBBPayorShare As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = IBB_PayorShare ];

/// IBB_PatientShare
Property IBBPatientShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = IBB_PatientShare ];

/// Bill Date
Property IBBBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = IBB_BillDate ];

/// IBB_BillTime
Property IBBBillTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = IBB_BillTime ];

/// IBB_BillStatus
Property IBBBillStatus As %Library.String(DISPLAYLIST = ",Billed,Paid,Refund,RefundPaid", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",B,P,R,RP") [ SqlColumnNumber = 13, SqlFieldName = IBB_BillStatus ];

/// IBB_CreateDate
Property IBBCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = IBB_CreateDate ];

/// IBB_CreateTime
Property IBBCreateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = IBB_CreateTime ];

/// IBB_BillUser
Property IBBBillUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = IBB_BillUser ];

/// IBB_ExecDept_Dr
Property IBBExecDeptDr As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = IBB_ExecDept_Dr ];

/// IBB_DiscPrice
Property IBBDiscPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = IBB_DiscPrice ];

/// IBB_InsPrice
Property IBBInsPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = IBB_InsPrice ];

/// IBB_PatPrice
Property IBBPatPrice As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = IBB_PatPrice ];

/// IBB_TradeSub_Dr
Property IBBTradeSubDr As User.DHCINVBankTradeSub [ SqlColumnNumber = 21, SqlFieldName = IBB_TradeSub_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IBB_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IBB_BillQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBB_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IBB_BillTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IBB_BillUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IBB_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IBB_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IBB_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IBB_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IBB_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IBB_ExecDept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IBB_IBP_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBB_InsPrice">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IBB_PatPrice">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IBB_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IBB_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IBB_Sub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IBB_TARI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBB_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IBB_TradeSub_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IBB_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINVBTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IBB_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBB_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTradeSub">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IBB_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TradeSub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBB_TradeSub_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IBB_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVBankBillDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
