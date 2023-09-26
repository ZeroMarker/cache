Class User.DHCPEEDLoc Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EDL_RowId, SqlTableName = DHC_PE_EDLoc, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEEDLoc";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On EDLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_ExpertDiagnosis Parent Reference
Relationship EDLParRef As User.DHCPEExpertDiagnosis [ Cardinality = parent, Inverse = ChildDHCPEEDLoc, Required, SqlFieldName = EDL_ParRef ];

/// EDL_ChildSub
Property EDLChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEED($p(%d(0),$c(1),1),"EDL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = EDL_ChildSub ];

/// EDL_Loc_DR
Property EDLLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EDL_Loc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEEDL">
<Data name="EDL_Loc_DR">
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
<Field>EDL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_ExpertDiagnosis.ED_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EDL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EDLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EDL_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEEDLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
