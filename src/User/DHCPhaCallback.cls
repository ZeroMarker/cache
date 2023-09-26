Class User.DHCPhaCallback Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPC_RowID, SqlTableName = DHC_PhaCallback, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaCallbackItm As User.DHCPhaCallbackItm [ Cardinality = children, Inverse = DHCPCIDHCPCParRef ];

/// DHCPC_No
Property DHCPCNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = DHCPC_No ];

/// DHCPC_Ward_DR User.PACWard
Property DHCPCWardDR As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = DHCPC_Ward_DR ];

/// DHCPC_CreateDate
Property DHCPCCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCPC_CreateDate ];

/// DHCPC_CreateUser User.SSUser
Property DHCPCCreateUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DHCPC_CreateUser ];

/// DHCPC_AckDate
Property DHCPCAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCPC_AckDate ];

/// DHCPC_AckUser User.SSUser
Property DHCPCAckUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCPC_AckUser ];

/// DHCPC_AckFlag
Property DHCPCAckFlag As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DHCPC_AckFlag ];

/// DHCPC_PrintFlag
Property DHCPCPrintFlag As %Library.Numeric(SCALE = 0) [ InitialExpression = 0, SqlColumnNumber = 9, SqlFieldName = DHCPC_PrintFlag ];

/// DHCPC_DispLoc User.CTLoc
Property DHCPCDispLoc As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = DHCPC_DispLoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCB)</SqlIdExpression>
<SQLMap name="DHCPhaCallbackMaster">
<Data name="DHCPC_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPC_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCPC_AckUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPC_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPC_DispLoc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCPC_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPC_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPC_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPCB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCPC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCallbackNo">
<Global>^DHCPCB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CallbackNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPC_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCPCB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCPC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPC_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPC_Ward_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdisplocward">
<Global>^DHCPCB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCPC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DispLocWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPC_DispLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPC_Ward_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCallbackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPCB)
	s oldI = +$g(^mdata("DHCPHACALLBACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPCB = maxI
	s ^mdata("DHCPHACALLBACK") = maxI
}

}
