Class User.DHCBillExtTradeOrdSub Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ETO_RowID, SqlTableName = DHC_BillExtTradeOrdSub, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ETOSub [ IdKey, PrimaryKey, Unique ];

/// DHCBillExtTradePay Parent Reference
Relationship ETOETPParRef As User.DHCBillExtTradePay [ Cardinality = parent, Inverse = ChildDHCBillExtTradeOrdSub, Required, SqlFieldName = ETO_ETP_ParRef ];

/// ETO_Sub
Property ETOSub As %Library.Float [ InitialExpression = {$i(^DHCBILLETP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"O",0))}, SqlColumnNumber = 2, SqlFieldName = ETO_Sub ];

/// ETO_OEORDER
Property ETOOEORDER As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = ETO_OEORDER ];

/// ETO_ARCIMDR
Property ETOARCIMDR As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ETO_ARCIMDR ];

/// ETO_ArmStatus
Property ETOArmStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ETO_ArmStatus ];

/// ETO_Price
Property ETOPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ETO_Price ];

/// ETO_Qty
Property ETOQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ETO_Qty ];

/// ETO_TotalAmt
Property ETOTotalAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ETO_TotalAmt ];

/// ETO_PBORDER
Property ETOPBORDER As User.DHCPatBillOrder [ SqlColumnNumber = 9, SqlFieldName = ETO_PBORDER ];

/// / ETO_PayorShare
Property ETOPayorShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ETO_PayorShare ];

/// ETO_DiscAmount
Property ETODiscAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ETO_DiscAmount ];

/// ETO_PatientShare
Property ETOPatientShare As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ETO_PatientShare ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ETO_ARCIMDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ETO_ArmStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ETO_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ETO_OEORDER">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ETO_PBORDER">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ETO_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ETO_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ETO_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ETO_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ETO_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCBILLETP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BillExtTradePay.ETP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ETO_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_BillExtTradePay.ETP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ETO_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBillExtTradeOrdSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
