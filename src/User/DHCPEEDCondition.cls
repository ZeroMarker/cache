Class User.DHCPEEDCondition Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EDC_RowId, SqlTableName = DHC_PE_EDCondition, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEEDCondition";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On EDCChildSub [ IdKey, PrimaryKey, Unique ];

/// EDC_ChildSub
Property EDCChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCPEED($p(%d(0),$c(1),1),"C",0))}, Required, SqlColumnNumber = 2, SqlFieldName = EDC_ChildSub ];

/// EDC_ODS_DR
Property EDCODSDR As User.DHCPEODStandard [ SqlColumnNumber = 3, SqlFieldName = EDC_ODS_DR ];

/// DHC_PE_ExpertDiagnosis Parent Reference
Relationship EDCParRef As User.DHCPEExpertDiagnosis [ Cardinality = parent, Inverse = ChildDHCPEEDCondition, Required, SqlFieldName = EDC_ParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEEDC">
<Data name="EDC_ODS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_ExpertDiagnosis.ED_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EDC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexODS">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_ExpertDiagnosis.ED_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EDC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ODS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDC_ODS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EDC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParRef">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_ExpertDiagnosis.ED_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EDC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDRowId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EDC_ODS_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EDC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEEDConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
