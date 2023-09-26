Class User.DHCPHCURRWIN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCW_ROWID, SqlTableName = DHC_PHCURRWIN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCW_DATE
Property PHCWDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHCW_DATE ];

/// PHCW_PHL_DR
Property PHCWPHLDR As User.DHCPHLOC [ SqlColumnNumber = 2, SqlFieldName = PHCW_PHL_DR ];

/// PHCW_PHW_DR
Property PHCWPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 3, SqlFieldName = PHCW_PHW_DR ];

/// PHCW_Type  1-毒麻类窗口，2-草药类   3-指定窗口  10--普通
Property PHCWType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCW_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCW)</SqlIdExpression>
<SQLMap name="PHCWMASTER">
<Data name="PHCW_DATE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCW_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCW_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCW_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHCW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCW_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCW_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCURRWINS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCW)
	s oldI = +$g(^mdata("DHCPHCURRWIN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCW = maxI
	s ^mdata("DHCPHCURRWIN") = maxI
}

}
