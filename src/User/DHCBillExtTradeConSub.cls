Class User.DHCBillExtTradeConSub Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ETC_RowID, SqlTableName = DHC_BillExtTradeConSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ETCSub [ IdKey, PrimaryKey, Unique ];

/// DHCBillExtTradePay Parent Reference
Relationship ETCETPParRef As User.DHCBillExtTradePay [ Cardinality = parent, Inverse = ChildDHCBillExtTradeConSub, Required, SqlFieldName = ETC_ETP_ParRef ];

/// ETC_Sub
Property ETCSub As %Library.Float [ InitialExpression = {$i(^DHCBILLETP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"C",0))}, SqlColumnNumber = 2, SqlFieldName = ETC_Sub ];

/// ETC_HISPRT_DR 关联业务表指针
Property ETCHISPRTDR As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ETC_HISPRT_DR ];

/// ETC_ConsultStatus 业务表状态
Property ETCConsultStatus As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 4, SqlFieldName = ETC_ConsultStatus ];

/// ETC_PRTPayMode_DR 业务表支付表指向
Property ETCPRTPayModeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ETC_PRTPayMode_DR ];

/// ETC_Status 交易状态
Property ETCStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ETC_Status ];

/// ETC_TradeType 交易类型(同主表,医生站发卡时充值预交金除外)
Property ETCTradeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ETC_TradeType ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ETC_ConsultStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ETC_HISPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ETC_PRTPayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ETC_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ETC_TradeType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCBILLETP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ETC_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETC_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTTypePRT">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ETC_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TTypePRT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETC_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETC_HISPRT_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ETC_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTTypePayM">
<Global>^DHCBILLETPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ETC_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TTypePM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETC_TradeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PayM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ETC_PRTPayMode_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ETC_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillExtTradeConSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
