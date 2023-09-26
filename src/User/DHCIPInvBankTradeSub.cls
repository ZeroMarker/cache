Class User.DHCIPInvBankTradeSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPInv_RowId, SqlTableName = DHC_IPInvBankTradeSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IPInvSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IPInvBankParref As User.DHCINVBankTradePay [ Cardinality = parent, Inverse = ChildDHCIPInvBankTradeSub, Required, SqlFieldName = IPInv_Bank_Parref ];

/// IPInv_Sub
Property IPInvSub As %Library.Float [ InitialExpression = {$i(^DHCIPINVBANKTRADESUB($p(%d(0),$c(1)),"IPInv",0))}, SqlColumnNumber = 2, SqlFieldName = IPInv_Sub ];

/// IPInv_Prt_Dr
Property IPInvPrtDr As User.DHCINVPRTZY [ SqlColumnNumber = 3, SqlFieldName = IPInv_Prt_Dr ];

/// IPInv_ConsultStatus
Property IPInvConsultStatus As %Library.String(MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 4, SqlFieldName = IPInv_ConsultStatus ];

/// IPInv_ARPayM_DR
Property IPInvARPayMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IPInv_ARPayM_DR ];

/// IPInv_Deposit_DR
Property IPInvDepositDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPInv_Deposit_DR ];

/// IPInv_Status
Property IPInvStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IPInv_Status ];

/// IPInv_Note1
Property IPInvNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IPInv_Note1 ];

/// IPInv_Note2
Property IPInvNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IPInv_Note2 ];

/// IPInv_Note3
Property IPInvNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IPInv_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IPInv_ARPayM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPInv_Bank_Parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPInv_ConsultStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPInv_Deposit_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPInv_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPInv_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPInv_Note3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPInv_Prt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPInv_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPInv_Sub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCIPINVBANKTRADESUB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IPInv_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPInv_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARPaym">
<Global>^DHCIPINVBANKTRADESUB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPInv_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARPayM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPInv_ARPayM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"IPInv"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPInv_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepPrt">
<Global>^DHCIPINVBANKTRADESUB</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepPrt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPInv_Deposit_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"IPInv"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPInv_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvoice">
<Global>^DHCIPINVBANKTRADESUB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPInv_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Invoice"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPInv_Prt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"IPInv"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPInv_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPInvBankTradeSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
