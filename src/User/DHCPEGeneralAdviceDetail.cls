Class User.DHCPEGeneralAdviceDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GAD_RowId, SqlTableName = DHC_PE_GeneralAdviceDetail, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGeneralAdviceDetail";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GADChildsub [ IdKey, PrimaryKey, Unique ];

/// GAD_Childsub
Property GADChildsub As %Library.Float [ InitialExpression = {$i(^DHCPEGA($p(%d(0),$c(1),1),"EDDetail",0))}, Required, SqlColumnNumber = 2, SqlFieldName = GAD_Childsub ];

/// GAD_ED_DR
Property GADEDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 3, SqlFieldName = GAD_ED_DR ];

/// DHC_PE_GeneralAdvice Parent Reference
Relationship GADParref As User.DHCPEGeneralAdvice [ Cardinality = parent, Inverse = ChildDHCPEGeneralAdviceDetail, Required, SqlFieldName = GAD_Parref ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEGA">
<Data name="GAD_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_GeneralAdvice.GA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GAD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralAdvice.GA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDDetail"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GAD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexED">
<Global>^DHCPEGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GeneralAdvice.GA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GAD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GAD_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralAdvice.GA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GAD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGeneralAdviceDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
