Class User.DHCOPAppConCate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPACC_RowID, SqlTableName = DHC_OPAppConCate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OPACCChildSub [ IdKey, PrimaryKey, Unique ];

/// OPACC_ChildSub
Property OPACCChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPAppCon(+%d(0),"C",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OPACC_ChildSub ];

/// OPACC_DateFrom
Property OPACCDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = OPACC_DateFrom ];

/// OPACC_DateTo
Property OPACCDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OPACC_DateTo ];

/// OPACC_MinAmount
Property OPACCMinAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = OPACC_MinAmount ];

/// DHC_OPAppCon Parent Reference
Relationship OPACCOPACParRef As User.DHCOPAppCon [ Cardinality = parent, Inverse = ChildDHCOPAppConCate, Required, SqlFieldName = OPACC_OPAC_ParRef ];

/// OPACC_TarSubCate_Dr
Property OPACCTarSubCateDr As User.DHCTarSubCate [ SqlColumnNumber = 3, SqlFieldName = OPACC_TarSubCate_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="dataDHCOPAppCon">
<Data name="OPACC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPACC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPACC_MinAmount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPACC_TarSubCate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPAppCon</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_OPAppCon.OPAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OPACC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_OPAppCon.OPAC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPACC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexTarSubCate">
<Global>^DHCOPAppCon</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_OPAppCon.OPAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OPACC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SubCate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPACC_TarSubCate_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_OPAppCon.OPAC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OPACC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPAppConCateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
