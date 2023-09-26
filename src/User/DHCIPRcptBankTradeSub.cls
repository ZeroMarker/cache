Class User.DHCIPRcptBankTradeSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPRcpt_RowId, SqlTableName = DHC_IPRcptBankTradeSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IPRcptSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IPRcptBankParref As User.DHCINVBankTradePay [ Cardinality = parent, Inverse = ChildDHCIPRcptBankTradeSub, Required, SqlFieldName = IPRcpt_Bank_Parref ];

/// IPRcpt_Sub
Property IPRcptSub As %Library.Float [ InitialExpression = {$i(^DHCIPRCPTBANKTRADESUB($p(%d(0),$c(1)),"IPRcpt",0))}, SqlColumnNumber = 2, SqlFieldName = IPRcpt_Sub ];

/// IPRcpt_Deposit_Dr
Property IPRcptDepositDr As User.dhcsfprintdetail [ SqlColumnNumber = 3, SqlFieldName = IPRcpt_Deposit_Dr ];

/// IPRcpt_ConsultStatus
Property IPRcptConsultStatus As %Library.String(MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 4, SqlFieldName = IPRcpt_ConsultStatus ];

/// IPRcpt_Note1
Property IPRcptNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IPRcpt_Note1 ];

/// IPRcpt_Status
Property IPRcptStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPRcpt_Status ];

/// IPRcpt_PaySeqNo
Property IPRcptPaySeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IPRcpt_PaySeqNo ];

/// IPRcpt_Note3
Property IPRcptNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IPRcpt_Note3 ];

/// IPRcpt_Note4
Property IPRcptNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IPRcpt_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IPRcpt_Bank_Parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPRcpt_ConsultStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPRcpt_Deposit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPRcpt_Note1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPRcpt_Note3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPRcpt_Note4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPRcpt_PaySeqNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPRcpt_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPRcpt_Sub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCIPRCPTBANKTRADESUB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IPRcpt_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPRcpt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRcpt_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDepositDr">
<Global>^DHCIPRCPTBANKTRADESUB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVBankTradePay.IBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPRcpt_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepositDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRcpt_Deposit_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVBankTradePay.IBP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"IPRcpt"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPRcpt_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPRcptBankTradeSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
