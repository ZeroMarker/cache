Class User.DHCMedInfectionICD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFI_Rowid, SqlTableName = DHC_MedInfectionICD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIFIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfection Parent Reference
Relationship MIFIParRef As User.DHCMedInfection [ Cardinality = parent, Inverse = ChildDHCMedInfectionICD, Required, SqlFieldName = MIFI_ParRef ];

/// Child subscript
Property MIFIChildSub As %Library.Float [ InitialExpression = {$i(^DHCMIF($p(%d(0),$c(1),1),"InfICD",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIFI_ChildSub ];

/// MIFI_ICDCode
Property MIFIICDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIFI_ICDCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="MIFI_ICDCode">
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
<Field>MIFI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InfICD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICD">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMIF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MedInfection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MIFI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"InfICD10"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFI_ICDCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIFI_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MIFI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
