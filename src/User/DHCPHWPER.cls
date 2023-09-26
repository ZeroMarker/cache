Class User.DHCPHWPER Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWP_ROWID, SqlTableName = DHC_PHWPER, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHWP_DOFLAG
Property PHWPDOFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHWP_DOFLAG ];

/// PHWP_PHL_DR
Property PHWPPHLDR As User.DHCPHLOC [ SqlColumnNumber = 3, SqlFieldName = PHWP_PHL_DR ];

/// PHWP_PHP_FYDR
Property PHWPPHPFYDR As User.DHCPHPERSON [ SqlColumnNumber = 5, SqlFieldName = PHWP_PHP_FYDR ];

/// PHWP_PHP_PYDR
Property PHWPPHPPYDR As User.DHCPHPERSON [ SqlColumnNumber = 4, SqlFieldName = PHWP_PHP_PYDR ];

/// PHWP_PHW_DR
Property PHWPPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 2, SqlFieldName = PHWP_PHW_DR ];

/// PHWP_ZTFLAG
Property PHWPZTFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHWP_ZTFLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHWP)</SqlIdExpression>
<SQLMap name="PHWPINDEX">
<Global>^DHCPHWPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHWP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"WINDOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHWP_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHWP_PHW_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHWP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHWPMASTER">
<Data name="PHWP_DOFLAG">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHWP_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHWP_PHP_FYDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHWP_PHP_PYDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHWP_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHWP_ZTFLAG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHWP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHWP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHWP_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phwpphl">
<Global>^DHCPHWPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHWP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHWP_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHWP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWPERS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHWP)
	s oldI = +$g(^mdata("DHCPHWPER"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHWP = maxI
	s ^mdata("DHCPHWPER") = maxI
}

}
