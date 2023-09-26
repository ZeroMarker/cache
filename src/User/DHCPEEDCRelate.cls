Class User.DHCPEEDCRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EDCR_RowId, SqlTableName = DHC_PE_EDCRelate, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEEDCRelate";

Parameter EXTENTSIZE = 250;

/// EDCR_ED_DR
Property EDCREDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 2, SqlFieldName = EDCR_ED_DR ];

/// EDCR_EDC_DR
Property EDCREDCDR As User.DHCPEEDClass [ SqlColumnNumber = 3, SqlFieldName = EDCR_EDC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEEDCR)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEEDCR">
<Data name="EDCR_EDC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EDCR_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEEDCR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EDCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EDCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfEDEDCDr">
<Global>^DHCPEEDCR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EDCR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EDEDCDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EDCR_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EDCR_EDC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEDCDR">
<Global>^DHCPEEDCR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EDCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDCDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDCR_EDC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EDCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEDDR">
<Global>^DHCPEEDCR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EDCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EDCR_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EDCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEEDCRelateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
