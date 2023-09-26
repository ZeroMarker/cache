Class User.DHCTARSUBCATCONFINE Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCTARCAT_ROWID, SqlTableName = DHC_TARSUBCAT_CONFINE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCTARCAT_SSGroup_DR
Property DHCTARCATSSGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = DHCTARCAT_SSGroup_DR ];

/// DHCTARCAT_TarSubCate_DR
Property DHCTARCATTarSubCateDR As User.DHCTarSubCate [ SqlColumnNumber = 3, SqlFieldName = DHCTARCAT_TarSubCate_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARCATCON)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCTARCAT_ROWID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCTARCAT_SSGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCTARCAT_TarSubCate_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCTARCATCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCTARCAT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCTARCAT_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSGroup">
<Global>^DHCTARCATCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCTARCAT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSGROUP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCTARCAT_SSGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCTARCAT_TarSubCate_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCTARCAT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTARSUBCATCONFINES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
