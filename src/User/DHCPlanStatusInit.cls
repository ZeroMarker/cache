Class User.DHCPlanStatusInit Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHCPSI_RowId, SqlTableName = DHC_PlanStatusInit, StorageStrategy = SQLStorage ]
{

/// DHCPSI_SSGRP_DR
Property DHCPSISSGRPDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = DHCPSI_SSGRP_DR ];

/// DHCPSI_DHCPS_DR
Property DHCPSIDHCPSDR As User.DHCPlanStatus [ SqlColumnNumber = 3, SqlFieldName = DHCPSI_DHCPS_DR ];

/// DHCPSI_CTLOC_DR
Property DHCPSICTLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DHCPSI_CTLOC_DR ];

/// DHCPSI_Level
Property DHCPSILevel As %String [ SqlColumnNumber = 5, SqlFieldName = DHCPSI_Level ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPSI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCPSI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPSI_DHCPS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPSI_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPSI_SSGRP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCPSI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^DHCPSI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPSI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPSI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPlanStatusInitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPSI)
	s oldI = +$g(^mdata("DHCPLANSTATUSINIT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPSI = maxI
	s ^mdata("DHCPLANSTATUSINIT") = maxI
}

}
