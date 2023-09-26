Class User.DHCPHSUPPLYITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SUPPI_ROWID, SqlTableName = DHC_PHSUPPLYITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SUPPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHSUPPLY Parent Reference
Relationship SUPPIParRef As User.DHCPHSUPPLY [ Cardinality = parent, Inverse = ChildDHCPHSUPPLYITM, Required, SqlFieldName = SUPPI_ParRef ];

/// SUPPI_POINTER
Property SUPPIPOINTER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SUPPI_POINTER ];

/// SUPPI_ChildSub
Property SUPPIChildSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SUPPI_ChildSub ];

/// SUPPI_TYPE
Property SUPPITYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SUPPI_TYPE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexPOINTER">
<Global>^DHCPHSUPPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHSUPPLY.SUPP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SUPPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"POINTER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUPPI_TYPE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SUPPI_POINTER}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SUPPI_ParRef}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SUPPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDATA">
<Data name="SUPPI_POINTER">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUPPI_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHSUPPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHSUPPLY.SUPP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SUPPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHSUPPLY.SUPP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SUPPI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSUPPLYITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
