Class User.DHCPEEDAlias Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EDA_RowId, SqlTableName = DHC_PE_EDAlias, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEEDAlias";

Parameter EXTENTSIZE = 250;

/// EDA_ED_DR
Property EDAEDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 2, SqlFieldName = EDA_ED_DR ];

/// EDA_Text
Property EDAText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EDA_Text ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEEDA)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEEDA">
<Data name="EDA_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EDA_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPEEDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EDA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EDA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfEDAlias">
<Global>^DHCPEEDA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EDAlias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EDA_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EDA_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexALIAS">
<Global>^DHCPEEDA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EDA_RowId</Field>
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
<Expression>$$ALPHAUP({EDA_Text})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EDA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEEDAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
