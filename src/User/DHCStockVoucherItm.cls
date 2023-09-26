Class User.DHCStockVoucherItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = SVCI_RowID, SqlTableName = DHC_StockVoucherItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SVCIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship SVCISVCParref As User.DHCStockVoucher [ Cardinality = parent, Inverse = ChildDHCStockVoucherItm, Required, SqlFieldName = SVCI_SVC_Parref ];

Property SVCIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SVCI_ChildSub ];

Property SVCIPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SVCI_Pointer ];

Property SVCIValidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SVCI_ValidFlag ];

Property SVCIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SVCI_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SVCI_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SVCI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SVCI_ValidFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSVC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StockVoucher.SVC_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SVCI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StockVoucher.SVC_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_StockVoucher.SVC_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SVCI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TPOINTERI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVCI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SVCI_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_StockVoucher.SVC_ROWID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SVCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SVCI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCStockVoucherItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
