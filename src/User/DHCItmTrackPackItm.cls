Class User.DHCItmTrackPackItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCITPI_RowId, SqlTableName = DHC_ItmTrackPackItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCITPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmTrack Parent Reference
Relationship DHCITPIDHCITParref As User.DHCItmTrack [ Cardinality = parent, Inverse = ChildDHCItmTrackPackItm, Required, SqlFieldName = DHCITPI_DHCIT_Parref ];

/// DHCITPI_ChildSub
Property DHCITPIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCITPI_ChildSub ];

/// DHCITPI_INCI_DR
Property DHCITPIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = DHCITPI_INCI_DR ];

/// DHCITPI_OriginalCode
Property DHCITPIOriginalCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHCITPI_OriginalCode ];

/// DHCITPI_BatchNo
Property DHCITPIBatchNo As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DHCITPI_BatchNo ];

/// DHCITPI_ExpDate
Property DHCITPIExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCITPI_ExpDate ];

/// DHCITPI_PHMNF_DR
Property DHCITPIPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 7, SqlFieldName = DHCITPI_PHMNF_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexINCI">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCITPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PACKINCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCITPI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCITPI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCITPI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCITPI_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCITPI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCITPI_OriginalCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCITPI_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCITPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PACKITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCITPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmTrackPackItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
