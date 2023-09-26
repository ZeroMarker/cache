Class User.DHCItmTrackDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCITD_Rowid, SqlTableName = DHC_ItmTrackDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCITDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmTrack Parent Reference
Relationship DHCITDParref As User.DHCItmTrack [ Cardinality = parent, Inverse = ChildDHCItmTrackDetail, Required, SqlFieldName = DHCITD_Parref ];

/// DHCITD_ChildSub
Property DHCITDChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCITD_ChildSub ];

/// DHCITD_Pointer
Property DHCITDPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCITD_Pointer ];

/// DHCITD_Type
Property DHCITDType As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCITD_Type ];

/// DHCITD_Type
Property DHCITDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCITD_Date ];

/// DHCITD_Time
Property DHCITDTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DHCITD_Time ];

/// DHCITD_SSUSR_DR
Property DHCITDSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCITD_SSUSR_DR ];

/// DHCITD_DHCITI_DR
Property DHCITDDHCITIDR As User.DHCItmTrackItm [ SqlColumnNumber = 8, SqlFieldName = DHCITD_DHCITI_DR ];

/// DHCITD_INTR_DR
Property DHCITDINTRDR As User.DHCINTRANS [ SqlColumnNumber = 9, SqlFieldName = DHCITD_INTR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDate">
<Global>^DHCITD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCITD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCITD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCITD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexTypePointer">
<Global>^DHCITD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DHCITD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCITD_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCITD_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{DHCITD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="mastermap">
<Data name="DHCITD_DHCITI_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCITD_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCITD_INTR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCITD_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCITD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCITD_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCITD_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCITD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCITD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCITD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmTrackDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
