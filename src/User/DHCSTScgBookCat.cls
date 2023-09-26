Class User.DHCSTScgBookCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCGBC_RowID, SqlTableName = DHCST_ScgBookCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SCGBCChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkCatGroup Parent Reference
Relationship SCGBCSCGParref As User.DHCStkCatGroup [ Cardinality = parent, Inverse = ChildDHCSTScgBookCat, Required, SqlFieldName = SCGBC_SCG_Parref ];

/// SCGBC_Childsub
Property SCGBCChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SCGBC_Childsub ];

/// DHCST_BookCat
Property SCGBCBCDr As User.DHCSTBookCat [ SqlColumnNumber = 3, SqlFieldName = SCGBC_BC_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SCGBC_BC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkCatGroup.SCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCGBC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkCatGroup.SCG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCGBC_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBC">
<Global>^DHCSCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkCatGroup.SCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SCGBC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BCCAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCGBC_BC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkCatGroup.SCG_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCGBC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTScgBookCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
