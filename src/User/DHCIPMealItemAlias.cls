Class User.DHCIPMealItemAlias Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMIA_RowID, SqlTableName = DHC_IPMealItemAlias, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCMIA_DHCMI_Dr
Property DHCMIADHCMIDr As User.DHCIPMealItem [ SqlColumnNumber = 2, SqlFieldName = DHCMIA_DHCMI_Dr ];

/// DHCMIA_Alias
Property DHCMIAAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCMIA_Alias ];

/// DHCMIA_Comment1
Property DHCMIAComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCMIA_Comment1 ];

/// DHCMIA_Comment2
Property DHCMIAComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCMIA_Comment2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALITEMALIAS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCMIA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMIA_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMIA_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMIA_DHCMI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCIPMEALITEMALIAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMIA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMIA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCIPMEALITEMALIAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMIA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMIA_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMIA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDHCMI">
<Global>^DHCIPMEALITEMALIAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMIA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DHCMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMIA_DHCMI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMIA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealItemAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
