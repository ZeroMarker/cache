Class User.DHCINVBankTradeSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBD_RowID, SqlTableName = DHC_INVBankTradeSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IBDSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IBDIBPParRef As User.DHCINVBankTradePay [ Cardinality = parent, Inverse = ChildDHCINVBankTradeSub, Required, SqlFieldName = IBD_IBP_ParRef ];

/// IBD_Sub
Property IBDSub As %Library.Float [ InitialExpression = {$i(^DHCINVBTP($p(%d(0),$c(1)),"D",0))}, SqlColumnNumber = 2, SqlFieldName = IBD_Sub ];

/// IBD_OEORDER
Property IBDOEORDER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IBD_OEORDER ];

/// IBD_ARCIMDR
Property IBDARCIMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IBD_ARCIMDR ];

/// IBD_ArmStatus
Property IBDArmStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IBD_ArmStatus ];

/// IBD_Price
Property IBDPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IBD_Price ];

/// IBD_Qty
Property IBDQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IBD_Qty ];

/// IBD_TotalAmt
Property IBDTotalAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IBD_TotalAmt ];

/// IBD_PBORDER
Property IBDPBORDER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IBD_PBORDER ];

/// / IBD_PayorShare
Property IBDPayorShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IBD_PayorShare ];

/// IBD_DiscAmount
Property IBDDiscAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IBD_DiscAmount ];

/// IBD_PatientShare
Property IBDPatientShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IBD_PatientShare ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IBD_ARCIMDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBD_ArmStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IBD_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IBD_OEORDER">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBD_PBORDER">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IBD_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IBD_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IBD_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IBD_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCINVBTP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IBD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IBD_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IBD_RowID</SqlRowIdName>
<StreamLocation>^User.DHCINVBankTradeSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
