/// DHC_MedRMOeordSubRank
Class User.DHCMedRMOeordSubRank Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEDRS_Rowid, SqlTableName = DHC_MedRMOeordSubRank, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MEDRSChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedRMOeordRank Parent Reference
Relationship MEDRSdhcmedrmoeordParRef As User.DHCMedRMOeordRank [ Cardinality = parent, Inverse = ChildDHCMedRMOeordSubRank, Required, SqlFieldName = MEDRS_dhcmedrmoeord_ParRef ];

/// Child subscript
Property MEDRSChildsub As %Library.Float [ InitialExpression = {$i(^DHCMEDR($p(%d(0),$c(1),1),"SUBRANK",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MEDRS_Childsub ];

/// DHC_MedRMOeordSubRank Code
Property MEDRSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MEDRS_Code ];

/// DHC_MedRMOeordSubRank Desc
Property MEDRSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEDRS_Desc ];

/// ARC_ItemCat Rowid
Property MEDRSARCItemCatdr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MEDRS_ARC_ItemCat_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MEDRS_ARC_ItemCat_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDRS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDRS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRMOeordRank.MEDR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEDRS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_MedRMOeordRank.MEDR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBRANK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDRS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCItemCatDr">
<Global>^DHCMEDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRMOeordRank.MEDR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MEDRS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRMOeordRank.MEDR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ARCItemCat"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEDRS_ARC_ItemCat_dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEDRS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMEDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRMOeordRank.MEDR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MEDRS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRMOeordRank.MEDR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEDRS_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEDRS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMEDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRMOeordRank.MEDR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MEDRS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRMOeordRank.MEDR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEDRS_Desc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEDRS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedRMOeordSubRankS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
