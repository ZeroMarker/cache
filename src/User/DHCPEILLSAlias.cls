Class User.DHCPEILLSAlias Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ILLSA_RowID, SqlTableName = DHC_PE_ILLSAlias, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEILLSAlias";

Parameter EXTENTSIZE = 250;

/// ILLSA_ILLS_DR
Property ILLSAILLSDR As User.DHCPEIllnessStandard [ SqlColumnNumber = 2, SqlFieldName = ILLSA_ILLS_DR ];

/// ILLSA_Text
Property ILLSAText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ILLSA_Text ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEILLSA)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEILLSA">
<Data name="ILLSA_ILLS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILLSA_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPEILLSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILLSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ILLSA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfILLSDRText">
<Global>^DHCPEILLSA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ILLSA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ILLSDRText"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ILLSA_ILLS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ILLSA_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ILLSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexALIAS">
<Global>^DHCPEILLSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ILLSA_Text})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILLSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEILLSAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
