Class User.DHCItmTrackItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCITI_Rowid, SqlTableName = DHC_ItmTrackItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCITIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmTrack Parent Reference
Relationship DHCITIParref As User.DHCItmTrack [ Cardinality = parent, Inverse = ChildDHCItmTrackItm, Required, SqlFieldName = DHCITI_DHCIT_Parref ];

/// DHCITI_ChildSub
Property DHCITIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCITI_ChildSub ];

/// DHCITI_INCIB_DR
Property DHCITIINCIBDR As User.INCItmBat [ SqlColumnNumber = 3, SqlFieldName = DHCITI_INCIB_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexIncib">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ITMINCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCITI_INCIB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCITI_INCIB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmTrack.DHCIT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ItmTrack.DHCIT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCITI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmTrackItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
