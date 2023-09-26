Class User.DHCSubLocUserGroup Extends %Persistent [ ClassType = persistent, SqlRowIdName = LUG_RowId, SqlTableName = DHC_SubLocUserGroup, StorageStrategy = SqlStorage ]
{

Relationship ChildDHCSubLocUser As DHCSubLocUser [ Cardinality = children, Inverse = SLUGroupParref ];

/// LUG_GroupCode
Property LUGGroupCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LUG_GroupCode ];

/// LUG_GroupDesc
Property LUGGroupDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LUG_GroupDesc ];

/// LUG_DateFrom
Property LUGDateFrom As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = LUG_DateFrom ];

/// LUG_DateTo
Property LUGDateTo As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = LUG_DateTo ];

/// LUG_CTLOC_DR
Property LUGCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = LUG_CTLOC_DR ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLUG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LUG_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LUG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LUG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LUG_GroupCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LUG_GroupDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLUG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LUG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LUG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCtLoc">
<Global>^DHCLUG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{LUG_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LUG_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LUG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LUG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSubLocUserGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLUG)
	s oldI = +$g(^mdata("DHCSUBLOCUSERGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLUG = maxI
	s ^mdata("DHCSUBLOCUSERGROUP") = maxI
}

}
