Class User.DHCPHUNRETURN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUNR_ROWID, SqlTableName = DHC_PHUNRETURN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHUNRETITM As User.DHCPHUNRETITM [ Cardinality = children, Inverse = PHUNRIPHUNRPARREF ];

/// PHUNR_CUFLAG1
Property PHUNRCUFLAG1 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHUNR_CUFLAG1 ];

/// PHUNR_CUFLAG2
Property PHUNRCUFLAG2 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHUNR_CUFLAG2 ];

/// PHUNR_CUFLAG3
Property PHUNRCUFLAG3 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHUNR_CUFLAG3 ];

/// PHUNR_DATE
Property PHUNRDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHUNR_DATE ];

/// PHUNR_FINFLAG
Property PHUNRFINFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHUNR_FINFLAG ];

/// PHUNR_INADJ_DR
Property PHUNRINADJDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PHUNR_INADJ_DR ];

/// PHUNR_MONTH
Property PHUNRMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHUNR_MONTH ];

/// PHUNR_PATTYPE
Property PHUNRPATTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHUNR_PATTYPE ];

/// PHUNR_PHCODE
Property PHUNRPHCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHUNR_PHCODE ];

/// PHUNR_PHINP_DR
Property PHUNRPHINPDR As User.DHCPHINPERSON [ SqlColumnNumber = 3, SqlFieldName = PHUNR_PHINP_DR ];

/// PHUNR_PHL_DR
Property PHUNRPHLDR As User.DHCPHLOC [ SqlColumnNumber = 7, SqlFieldName = PHUNR_PHL_DR ];

/// PHUNR_PHP_DR
Property PHUNRPHPDR As User.DHCPHPERSON [ SqlColumnNumber = 8, SqlFieldName = PHUNR_PHP_DR ];

/// PHUNR_PHUNDR_DR
Property PHUNRPHUNDRDR As User.DHCPHUNDISPEN [ SqlColumnNumber = 15, SqlFieldName = PHUNR_PHUNDR_DR ];

/// PHUNR_TIME
Property PHUNRTIME As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHUNR_TIME ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHUNR)</SqlIdExpression>
<SQLMap name="PHUNRETINDEX1">
<Global>^DHCPHUNRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHUNR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUNR_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUNR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHUNRINDEX2">
<Global>^DHCPHUNRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHUNR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUNR_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUNR_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHUNR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHUNRMASTER">
<Data name="PHUNR_CUFLAG1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUNR_CUFLAG2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUNR_CUFLAG3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUNR_DATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUNR_FINFLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHUNR_INADJ_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHUNR_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHUNR_PATTYPE">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHUNR_PHCODE">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHUNR_PHINP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHUNR_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHUNR_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHUNR_PHUNDR_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHUNR_TIME">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPHUNR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHUNR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUNR_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNRETURNS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHUNR)
	s oldI = +$g(^mdata("DHCPHUNRETURN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHUNR = maxI
	s ^mdata("DHCPHUNRETURN") = maxI
}

}
