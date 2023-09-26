Class User.DHCINCEasyConDesc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIEC_RowID, SqlTableName = DHC_INCEasyConDesc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCIEC_INCI_dr
Property DHCIECINCIdr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = DHCIEC_INCI_dr ];

/// DHCIEC_Type
Property DHCIECType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCIEC_Type ];

/// DHCIEC_ConINCI_dr
Property DHCIECConINCIdr As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = DHCIEC_ConINCI_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINCEC)</SqlIdExpression>
<SQLMap name="IndexConDr">
<Global>^DHCINCEC</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>{DHCIEC_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIEC_INCI_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIEC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCIEC_ConINCI_dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCIEC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCINCEC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{DHCIEC_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIEC_INCI_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIEC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCIEC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCIEC">
<Data name="DHCIEC_ConINCI_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCIEC_INCI_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIEC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINCEC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{DHCIEC_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCIEC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCIEC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCINCEasyConDescS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINCEC)
	s oldI = +$g(^mdata("DHCINCEASYCONDESC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINCEC = maxI
	s ^mdata("DHCINCEASYCONDESC") = maxI
}

}
