Class User.DHCPHAdrStatusGrant Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRSG_RowID, SqlTableName = DHC_PHAdrStatusGrant, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRSGChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrStatus Parent Reference ADRSG_ADRS_Parref
Relationship ADRSGADRSParref As User.DHCPHAdrStatus [ Cardinality = parent, Inverse = ChildDHCPHADRSTATUSGRANT, Required, SqlFieldName = ADRSG_ADRS_Parref ];

/// ADRSG_ChildSub
Property ADRSGChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRSG_ChildSub ];

/// ADRSG_Type
Property ADRSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRSG_Type ];

/// ADRSG_Pointer
Property ADRSPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADRSG_Pointer ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRSG_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRSG_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHADRS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdrStatus.ADRS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADRSG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrStatus.ADRS_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRSG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCPHADRS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PHAdrStatus.ADRS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ADRSG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRSG_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRSG_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHAdrStatus.ADRS_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADRSG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrStatusGrantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
