Class User.DHCPlanAudit Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHCPA_RowId, SqlTableName = DHC_PlanAudit, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPlanAuditItm As User.DHCPlanAuditItm [ Cardinality = children, Inverse = DHCPAIDHCPAParRef ];

/// DHCPA_INPP_DR
Property DHCPAINPPDR As User.INPurPlan [ SqlColumnNumber = 2, SqlFieldName = DHCPA_INPP_DR ];

/// DHCPA_DHCPS_DR
Property DHCPADHCPSDR As User.DHCPlanStatus [ SqlColumnNumber = 3, SqlFieldName = DHCPA_DHCPS_DR ];

/// DHCPA_Date
Property DHCPADate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DHCPA_Date ];

/// DHCPA_SSUSR_DR
Property DHCPASSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DHCPA_SSUSR_DR ];

/// DHCPA_Time
Property DHCPATime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DHCPA_Time ];

/// DHCPA_Remark
Property DHCPARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCPA_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCPA_DHCPS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPA_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPA_INPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPA_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPA_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINPP">
<Global>^DHCPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_INPP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_DHCPS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPA_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPlanAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPA)
	s oldI = +$g(^mdata("DHCPLANAUDIT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPA = maxI
	s ^mdata("DHCPLANAUDIT") = maxI
}

}
