Class User.DHCINVBankConSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBS_RowID, SqlTableName = DHC_INVBankConSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IBSSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IBSIBPParRef As User.DHCINVBankTradePay [ Cardinality = parent, Inverse = ChildDHCINVBankConSub, Required, SqlFieldName = IBS_IBP_ParRef ];

/// IBS_Sub
Property IBSSub As %Library.Float [ InitialExpression = {$i(^DHCINVBTP($p(%d(0),$c(1)),"C",0))}, SqlColumnNumber = 2, SqlFieldName = IBS_Sub ];

/// IBS_INVPRT_DR 关联业务表指针
Property IBSINVPRTDR As %Library.String [ SqlColumnNumber = 3, SqlFieldName = IBS_INVPRT_DR ];

/// IBS_ConsultStatus 发票状态
Property IBSConsultStatus As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 4, SqlFieldName = IBS_ConsultStatus ];

/// IBS_InvPayMode_DR 业务表支付子表ID
Property IBSInvPayModeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IBS_InvPayMode_DR ];

/// IBS_Status 交易状态
Property IBSStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IBS_Status ];

/// IBS_PaySeqNo 暂未用
Property IBSPaySeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IBS_PaySeqNo ];

/// IBS_TradeType 交易类型(同主表,医生站发卡时充值预交金除外)
Property IBSTradeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IBS_TradeType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IBS_ConsultStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IBS_INVPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBS_InvPayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBS_PaySeqNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBS_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IBS_TradeType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINVBTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IBS_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IBS_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINVPRT">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>IBS_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"IPDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IBS_INVPRT_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"C"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{IBS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaySeqNo">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IBS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PaySeqNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBS_PaySeqNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTTypePRT">
<Global>^DHCINVBTPi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>IBS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TTypePRT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBS_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBS_INVPRT_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{IBS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTTypePayM">
<Global>^DHCINVBTPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>IBS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TTypePM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBS_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PayM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBS_InvPayMode_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{IBS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVBankConSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
