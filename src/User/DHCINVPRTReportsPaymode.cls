Class User.DHCINVPRTReportsPaymode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HisPay_RowID, SqlTableName = DHC_INVPRTReportsPaymode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HisPayChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTReports Parent Reference
Relationship HisPayParRef As User.DHCINVPRTReports [ Cardinality = parent, Inverse = ChildDHCINVPRTReportsPaymode, Required, SqlFieldName = HisPay_ParRef ];

/// HisPay_ChildSub 支付方式指针
Property HisPayChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPInsFoot($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = HisPay_ChildSub ];

/// HisPay_Paymode
Property HisPayPaymode As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = HisPay_Paymode ];

/// HisPay_PRTPaySum 收费金额
Property HisPayPRTPaySum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = HisPay_PRTPaySum ];

/// HisPay_PRTPayNum 收费数量
Property HisPayPRTPayNum As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = HisPay_PRTPayNum ];

/// HisPay_PRTRefundSum  退费金额
Property HisPayPRTRefundSum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = HisPay_PRTRefundSum ];

/// HisPay_PRTRefundNum 退费数量
Property HisPayPRTRefundNum As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = HisPay_PRTRefundNum ];

/// HisPay_APIPaySum 集中打印发票金额
Property HisPayAPIPaySum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = HisPay_APIPaySum ];

/// HisPay_APIPayNum 集中打印发票数量
Property HisPayAPIPayNum As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = HisPay_APIPayNum ];

/// HisPay_APIRefundSum 集中打印发票作废/红冲金额
Property HisPayAPIRefundSum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = HisPay_APIRefundSum ];

/// HisPay_APIRefundNum 集中打印发票作废/红冲数量
Property HisPayAPIRefundNum As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = HisPay_APIRefundNum ];

/// HisPay_PRDGetSum 收预交金金额
Property HisPayPRDGetSum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = HisPay_PRDGetSum ];

/// HisPay_PRDGetNum 收预交金笔数
Property HisPayPRDGetNum As %Library.Integer [ SqlColumnNumber = 13, SqlFieldName = HisPay_PRDGetNum ];

/// HisPay_PRDParkSum 退预交金金额
Property HisPayPRDParkSum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = HisPay_PRDParkSum ];

/// HisPay_PRDParkNum 退预交金笔数
Property HisPayPRDParkNum As %Library.Integer [ SqlColumnNumber = 15, SqlFieldName = HisPay_PRDParkNum ];

/// HisPay_CardPaySum 建卡金额
Property HisPayCardPaySum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = HisPay_CardPaySum ];

/// HisPay_CardPayNum 建卡张数
Property HisPayCardPayNum As %Library.Integer [ SqlColumnNumber = 17, SqlFieldName = HisPay_CardPayNum ];

/// HisPay_CardRefundSum 退卡金额
Property HisPayCardRefundSum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = HisPay_CardRefundSum ];

/// HisPay_CardRefundNum 退卡张数
Property HisPayCardRefundNum As %Library.Integer [ SqlColumnNumber = 19, SqlFieldName = HisPay_CardRefundNum ];

/// HisPay_EPDGetSum 收留观押金金额
Property HisPayEPDGetSum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = HisPay_EPDGetSum ];

/// HisPay_EPDGetNum 收留观押金笔数
Property HisPayEPDGetNum As %Library.Integer [ SqlColumnNumber = 21, SqlFieldName = HisPay_EPDGetNum ];

/// HisPay_EPDParkSum 退留观押金金额
Property HisPayEPDParkSum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = HisPay_EPDParkSum ];

/// HisPay_EPDParkNum 退留观押金笔数
Property HisPayEPDParkNum As %Library.Integer [ SqlColumnNumber = 23, SqlFieldName = HisPay_EPDParkNum ];

/// HisPay_ChargeType 业务类型
Property HisPayChargeType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = HisPay_ChargeType ];

/// HisPay_GiftCardPaySum 建代金卡金额
Property HisPayGiftCardPaySum As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = HisPay_GiftCardPaySum ];

/// HisPay_GiftCardPayNum 建代金卡张数
Property HisPayGiftCardPayNum As %Library.Integer [ SqlColumnNumber = 26, SqlFieldName = HisPay_GiftCardPayNum ];

/// HisPay_GiftCardRefundSum 退代金卡金额
Property HisPayGiftCardRefundSum As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = HisPay_GiftCardRefundSum ];

/// HisPay_GiftCardRefundNum 退代金卡张数
Property HisPayGiftCardRefundNum As %Library.Integer [ SqlColumnNumber = 28, SqlFieldName = HisPay_GiftCardRefundNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HisPay_APIPayNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HisPay_APIPaySum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HisPay_APIRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HisPay_APIRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HisPay_CardPayNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HisPay_CardPaySum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HisPay_CardRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HisPay_CardRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HisPay_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HisPay_EPDGetNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HisPay_EPDGetSum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HisPay_EPDParkNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HisPay_EPDParkSum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="HisPay_GiftCardPayNum">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HisPay_GiftCardPaySum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="HisPay_GiftCardRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HisPay_GiftCardRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HisPay_PRDGetNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HisPay_PRDGetSum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HisPay_PRDParkNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HisPay_PRDParkSum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HisPay_PRTPayNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HisPay_PRTPaySum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HisPay_PRTRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HisPay_PRTRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HisPay_Paymode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPInsFoot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTReports.HIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HisPay_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRTReports.HIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HisPay_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsPaymodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
