Class User.DHCTARITEMCONFINE Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCTARCON_Rwoid, SqlTableName = DHC_TARITEM_CONFINE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCTAR_TarItem_DR
Property DHCTARCONTarItemDR As User.DHCTarItem [ SqlColumnNumber = 2, SqlFieldName = DHCTARCON_TarItem_DR ];

/// DHCTAR_SSGroup_DR
Property DHCTARCONSSGroupDR As User.SSGroup [ SqlColumnNumber = 3, SqlFieldName = DHCTARCON_SSGroup_DR ];

/// DHCTAR_TarSubCate_DR
Property DHCTARCONTarSubCateDR As User.DHCTarSubCate [ SqlColumnNumber = 4, SqlFieldName = DHCTARCON_TarSubCate_DR ];

/// DHCTAR_StrDate
Property DHCTARCONStrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCTARCON_StrDate ];

/// DHCTARCON_EndDate
Property DHCTARCONEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCTARCON_EndDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARCON)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCTARCON_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCTARCON_Rwoid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCTARCON_SSGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCTARCON_StrDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCTARCON_TarItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCTARCON_TarSubCate_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCTARCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCTARCON_Rwoid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCTARCON_Rwoid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSGroup">
<Global>^DHCTARCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCTARCON_Rwoid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSGroup"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCTARCON_SSGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCTARCON_TarItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCTARCON_Rwoid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTARITEMCONFINES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
