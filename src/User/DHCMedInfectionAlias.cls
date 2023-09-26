Class User.DHCMedInfectionAlias Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFA_Rowid, SqlTableName = DHC_MedInfectionAlias, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIFAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfection Parent Reference
Relationship MIFAParRef As User.DHCMedInfection [ Cardinality = parent, Inverse = ChildDHCMedInfectionAlias, Required, SqlFieldName = MIFA_ParRef ];

/// Child subscript
Property MIFAChildSub As %Library.Float [ InitialExpression = {$i(^DHCMIF($p(%d(0),$c(1),1),"InfAlias",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIFA_ChildSub ];

/// MIFA_Alias
Property MIFAAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIFA_Alias ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="MIFA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIFA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"InfAlias"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCMIF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MedInfection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MIFA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"InfALIAS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFA_Alias}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MIFA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
