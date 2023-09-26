Class User.DHCPHPYWIN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPY_ROWID, SqlTableName = DHC_PHPYWIN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHPYWINSUB As User.DHCPHPYWINSUB [ Cardinality = children, Inverse = PHPYSPHPYPARREF ];

/// PHPY_DESC
Property PHPYDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHPY_DESC ];

/// PHPY_DOFLAG
Property PHPYDOFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHPY_DOFLAG ];

/// PHPY_MIXFLAG
Property PHPYMIXFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHPY_MIXFLAG ];

/// PHPY_PHL_DR
Property PHPYPHLDR As User.DHCPHLOC [ SqlColumnNumber = 2, SqlFieldName = PHPY_PHL_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPY)</SqlIdExpression>
<SQLMap name="PHPYINDEX">
<Global>^DHCPHPYi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHPY_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHPY_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHPY_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHPYMASTER">
<Data name="PHPY_DESC">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPY_DOFLAG">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHPY_MIXFLAG">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHPY_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPY_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHPY_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPYWINS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHPY)
	s oldI = +$g(^mdata("DHCPHPYWIN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHPY = maxI
	s ^mdata("DHCPHPYWIN") = maxI
}

}
