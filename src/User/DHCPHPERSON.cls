Class User.DHCPHPERSON Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHP_ROWID, SqlTableName = DHC_PHPERSON, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHP_FYFLAG
Property PHPFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHP_FYFLAG ];

/// PHP_LEVEL
Property PHPLEVEL As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHP_LEVEL ];

/// PHP_MIXFLAG
Property PHPMIXFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHP_MIXFLAG ];

/// PHP_NAME
Property PHPNAME As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHP_NAME ];

/// PHP_PHL_DR
Property PHPPHLDR As User.DHCPHLOC [ SqlColumnNumber = 2, SqlFieldName = PHP_PHL_DR ];

/// PHP_PHW_DR
Property PHPPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 7, SqlFieldName = PHP_PHW_DR ];

/// PHP_PYFLAG
Property PHPPYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHP_PYFLAG ];

/// PHP_SSUSR_DR
Property PHPSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHP_SSUSR_DR ];

/// PHP_USEFLAG
Property PHPUSEFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHP_USEFLAG ];

/// PHP_KEYCODE
Property PHPKEYCODE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHP_KEYCODE ];

Property PHPLOCDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = PHP_LOC_DR ];

Property PHPPath As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHP_Path ];

Property PHPScheduling As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHP_Scheduling ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPER)</SqlIdExpression>
<SQLMap name="IndexPhlUser">
<Global>^DHCPHPERi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHP_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHLUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHP_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHP_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHPINDEX">
<Global>^DHCPHPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"USR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHP_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHPMASTER">
<Data name="PHP_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHP_KEYCODE">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHP_LEVEL">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHP_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHP_MIXFLAG">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHP_NAME">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHP_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHP_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHP_PYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHP_Path">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHP_Scheduling">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHP_USEFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHP_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPERSONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHPER)
	s oldI = +$g(^mdata("DHCPHPERSON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHPER = maxI
	s ^mdata("DHCPHPERSON") = maxI
}

}
