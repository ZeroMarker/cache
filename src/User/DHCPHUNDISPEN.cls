Class User.DHCPHUNDISPEN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUND_ROWID, SqlTableName = DHC_PHUNDISPEN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHUNDISPITM As User.DHCPHUNDISPITM [ Cardinality = children, Inverse = PHUNDIPHUNDPARREF ];

/// PHUND_PHINP_DR
Property PHUNDPHINPDR As User.DHCPHINPERSON [ SqlColumnNumber = 2, SqlFieldName = PHUND_PHINP_DR ];

/// PHUND_PHSERIALNO
Property PHUNDPHSERIALNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHUND_PHSERIALNO ];

/// PHUND_MONTH
Property PHUNDMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHUND_MONTH ];

/// PHUND_DATE
Property PHUNDDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHUND_DATE ];

/// PHUND_TIME
Property PHUNDTIME As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHUND_TIME ];

/// PHUND_PHL_DR
Property PHUNDPHLDR As User.DHCPHLOC [ SqlColumnNumber = 7, SqlFieldName = PHUND_PHL_DR ];

/// PHUND_PHP_DR
Property PHUNDPHPDR As User.DHCPHPERSON [ SqlColumnNumber = 8, SqlFieldName = PHUND_PHP_DR ];

/// PHUND_FINFLAG
Property PHUNDFINFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHUND_FINFLAG ];

/// PHUND_CUFLAG1
Property PHUNDCUFLAG1 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHUND_CUFLAG1 ];

/// PHUND_CUFLAG2
Property PHUNDCUFLAG2 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHUND_CUFLAG2 ];

/// PHUND_CUFLAG3
Property PHUNDCUFLAG3 As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHUND_CUFLAG3 ];

/// PHUND_PATTYPE
Property PHUNDPATTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHUND_PATTYPE ];

/// PHUND_INADJ_DR
Property PHUNDINADJDR As User.INAdj [ SqlColumnNumber = 14, SqlFieldName = PHUND_INADJ_DR ];

/// PHUND_PHUNDR_DR
Property PHUNDPHUNDRDR As User.DHCPHUNDREAS [ SqlColumnNumber = 15, SqlFieldName = PHUND_PHUNDR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHUND)</SqlIdExpression>
<SQLMap name="PHUNDINDEX1">
<Global>^DHCPHUNDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHUND_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUND_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUND_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHUNDINDEX2">
<Global>^DHCPHUNDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHUND_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUND_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUND_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHUND_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHUNDMASTER">
<Data name="PHUND_CUFLAG1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUND_CUFLAG2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUND_CUFLAG3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUND_DATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUND_FINFLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHUND_INADJ_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHUND_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHUND_PATTYPE">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHUND_PHINP_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHUND_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHUND_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHUND_PHSERIALNO">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHUND_PHUNDR_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHUND_TIME">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPHUND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHUND_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUND_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNDISPENS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHUND)
	s oldI = +$g(^mdata("DHCPHUNDISPEN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHUND = maxI
	s ^mdata("DHCPHUNDISPEN") = maxI
}

}
