Class User.DHCPEEDBlackBall Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EDBB_RowId, SqlTableName = DHC_PE_EDBlackBall, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEEDBlackBall";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On EDBBChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_ExpertDiagnosis Parent Reference
Relationship EDBBParRef As User.DHCPEExpertDiagnosis [ Cardinality = parent, Inverse = ChildDHCPEEDBlackBall, Required, SqlFieldName = EDBB_ParRef ];

/// EDBB_ChildSub
Property EDBBChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEED($p(%d(0),$c(1),1),"EDBB",0))}, Required, SqlColumnNumber = 2, SqlFieldName = EDBB_ChildSub ];

/// EDBB_ED_DR
Property EDBBEDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 3, SqlFieldName = EDBB_ED_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEEDBB">
<Data name="EDBB_ED_DR">
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
<Field>EDBB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_ExpertDiagnosis.ED_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDBB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDBB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEEDBlackBallS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
