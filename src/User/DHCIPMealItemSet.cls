Class User.DHCIPMealItemSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMIS_RowID, SqlTableName = DHC_IPMealItemSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DHCMISCreatorDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DHCMIS_Creator_DR ];

Property DHCMISCreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCMIS_CreatDate ];

/// DHCMIS_CreatTime
Property DHCMISCreatTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DHCMIS_CreatTime ];

/// DHCMIS_Status A:作废，非A:正常
Property DHCMISStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCMIS_Status ];

/// DHCMIS_DHCMI_DR
Property DHCMISDHCMIDR As User.DHCIPMealItem [ SqlColumnNumber = 6, SqlFieldName = DHCMIS_DHCMI_DR ];

/// DHCMIS_DHCMISub_DR
Property DHCMISDHCMISubDR As User.DHCIPMealItem [ SqlColumnNumber = 7, SqlFieldName = DHCMIS_DHCMISub_DR ];

Property DHCMISAbortUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DHCMIS_AbortUser_DR ];

Property DHCMISAbortDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCMIS_AbortDate ];

Property DHCMISAbortTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCMIS_AbortTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALITEMSET)</SqlIdExpression>
<SQLMap name="IndexItemSetDR">
<Global>^DHCIPMEALITEMSET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMIS_DHCMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemSub">
<Global>^DHCIPMEALITEMSET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMIS_DHCMISub_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSet">
<Global>^DHCIPMEALITEMSET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITMSET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMIS_DHCMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITMSUB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMIS_DHCMISub_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCMIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MastIndex">
<Data name="DHCMIS_AbortDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMIS_AbortTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMIS_AbortUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMIS_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMIS_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMIS_Creator_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMIS_DHCMISub_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMIS_DHCMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMIS_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPMEALITEMSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMIS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealItemSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
