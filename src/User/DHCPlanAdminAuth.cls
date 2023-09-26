Class User.DHCPlanAdminAuth Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPlanAd_Rowid, SqlTableName = DHC_PlanAdminAuth, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCPlanAd_SSUser_DR
Property DHCPlanAdSSUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DHCPlanAd_SSUser_DR ];

/// DHCPlanAd_CTLOC
Property DHCPlanAdCTLOC As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCPlanAd_CTLOC ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPLANAD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCPlanAd_CTLOC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPlanAd_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPlanAd_SSUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPLANAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPlanAd_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCPlanAd_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSUSERDR">
<Global>^DHCPLANAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCPlanAd_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCPlanAd_SSUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPlanAd_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPlanAdminAuthS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
