Class User.DHCVendorInvItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = INVI_RowId, SqlTableName = DHC_VendorInvItm, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On INVIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship INVIINVParRef As User.DHCVendorInv [ Cardinality = parent, Inverse = ChildDHCVendorInvItm, Required, SqlFieldName = INVI_INV_ParRef ];

Property INVIChildSub As %Library.Float [ InitialExpression = {$i(^DHCVendorInv($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = INVI_ChildSub ];

/// 入库单(退货单)子表RowId
Property INVIINGRIDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INVI_INGRI_DR ];

/// 发票进价金额
Property INVIInvRpAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INVI_InvRpAmt ];

/// 发票售价金额
Property INVIInvSpAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INVI_InvSpAmt ];

/// 类型(G-入库,R-退货)
Property INVIType As %Library.String(DISPLAYLIST = ",Receive,Return", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",G,R") [ SqlColumnNumber = 6, SqlFieldName = INVI_Type ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INVI_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INVI_InvRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INVI_InvSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INVI_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_VendorInv.INV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_VendorInv.INV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INVI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeIngri">
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_VendorInv.INV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INVI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INVI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INVI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_VendorInv.INV_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INVI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INVI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorInvItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
