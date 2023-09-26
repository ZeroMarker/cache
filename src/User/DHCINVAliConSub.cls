Class User.DHCINVAliConSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IAS_RowID, SqlTableName = DHC_INVAliConSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IASSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IASIAPParRef As User.DHCINVAliTradePay [ Cardinality = parent, Inverse = ChildDHCINVAliConSub, Required, SqlFieldName = IAS_IAP_ParRef ];

/// IAS_Sub
Property IASSub As %Library.Float [ InitialExpression = {$i(^DHCINVALITP($p(%d(0),$c(1)),"C",0))}, SqlColumnNumber = 2, SqlFieldName = IAS_Sub ];

/// IAS_INVPRT_DR
Property IASINVPRTDR As User.DHCINVPRT [ SqlColumnNumber = 3, SqlFieldName = IAS_INVPRT_DR ];

/// IAS_ConsultStatus
Property IASConsultStatus As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 4, SqlFieldName = IAS_ConsultStatus ];

/// IAS_InvPayMode_DR
Property IASInvPayModeDR As User.DHCINVPayMode [ SqlColumnNumber = 5, SqlFieldName = IAS_InvPayMode_DR ];

/// IAS_Status
Property IASStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IAS_Status ];

/// IAS_PaySeqNo
Property IASPaySeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IAS_PaySeqNo ];

/// IAS_Note5
Property IASNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IAS_Note5 ];

/// IAS_Note6
Property IASNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IAS_Note6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IAS_ConsultStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IAS_INVPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IAS_InvPayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IAS_Note5">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IAS_Note6">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IAS_PaySeqNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IAS_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINVALITP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVAliTradePay.IAP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IAS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVAliTradePay.IAP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAS_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINVPRT">
<Global>^DHCINVALITPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_INVAliTradePay.IAP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>IAS_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"IPDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAS_INVPRT_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_INVAliTradePay.IAP_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IAS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVAliConSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
