Class User.DHCPlanStatus Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHCPS_RowId, SqlTableName = DHC_PlanStatus, StorageStrategy = SQLStorage ]
{

/// DHCPS_Code 	
Property DHCPSCode As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DHCPS_Code ];

/// DHCPS_Desc
Property DHCPSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCPS_Desc ];

/// DHCPS_MaxAmtAuthorized - 最高授权额度
Property DHCPSMaxAmtAuthorized As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DHCPS_MaxAmtAuthorized ];

/// DHCPS_StkType
Property DHCPSStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 5, SqlFieldName = DHCPS_StkType ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCPS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPS_MaxAmtAuthorized">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPS_StkType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCPS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPlanStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPS)
	s oldI = +$g(^mdata("DHCPLANSTATUS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPS = maxI
	s ^mdata("DHCPLANSTATUS") = maxI
}

}
