/// 报支单孙表
Class User.DHCReimPayInvItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = RPII_RowId, SqlTableName = DHC_ReimPayInvItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RPIIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship RPIIRPIParRef As User.DHCReimPayInv [ Cardinality = parent, Inverse = ChildDHCReimPayInvItm, Required, SqlFieldName = RPII_RPI_ParRef ];

Property RPIIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = RPII_ChildSub ];

/// 入库单(退货单)子表RowId
Property RPIIPointer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RPII_Pointer ];

/// 发票金额
Property RPIIInvRpAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RPII_InvRpAmt ];

/// 类型
Property RPIIType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RPII_Type ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="RPII_InvRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RPII_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RPII_Type">
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
<Field>DHC_ReimPayInv.RPI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RPII_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ReimPay.RP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ReimPayInv.RPI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"II"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RPII_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCREIMPAY</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_ReimPay.RP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_ReimPayInv.RPI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RPII_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPII_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RPII_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_ReimPay.RP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_ReimPayInv.RPI_ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RPII_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RPII_RowId</SqlRowIdName>
<StreamLocation>^User.DHCReimPayInvItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
