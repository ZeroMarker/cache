/// 报支单子表
Class User.DHCReimPayInv Extends (%Persistent, User.Abstract) [ SqlRowIdName = RPI_RowId, SqlTableName = DHC_ReimPayInv, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCReimPayInvItm As User.DHCReimPayInvItm [ Cardinality = children, Inverse = RPIIRPIParRef ];

Index RowIDBasedIDKeyIndex On RPIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship RPIRPParRef As User.DHCReimPay [ Cardinality = parent, Inverse = ChildDHCReimPayInv, Required, SqlFieldName = RPI_RP_ParRef ];

Property RPIChildSub As %Library.Float [ InitialExpression = {$i(^DHCREIMPAY($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = RPI_ChildSub ];

/// 发票号
Property RPIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RPI_InvNo ];

/// 发票进价金额
Property RPIInvRpAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RPI_InvRpAmt ];

/// 发票扣款金额
Property RPIUnPayRpAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = RPI_UnPayRpAmt ];

Property RPIAPCVMDR As User.APCVendor [ SqlColumnNumber = 6, SqlFieldName = RPI_APCVM_DR ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="RPI_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RPI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RPI_InvRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RPI_UnPayRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCREIMPAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ReimPay.RP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ReimPay.RP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvNo">
<Global>^DHCREIMPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ReimPay.RP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPI_InvNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_ReimPay.RP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RPI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCReimPayInvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
