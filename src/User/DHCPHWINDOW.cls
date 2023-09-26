Class User.DHCPHWINDOW Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHW_ROWID, SqlTableName = DHC_PHWINDOW, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHWINLOC As User.DHCPHWINLOC [ Cardinality = children, Inverse = PHWLParRef ];

/// PHW_DESC_
Property PHWDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHW_DESC ];

/// PHW_PHL_DR
Property PHWPHLDR As User.DHCPHLOC [ SqlColumnNumber = 3, SqlFieldName = PHW_PHL_DR ];

/// PHW_OK
Property PHWOK As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHW_OK ];

/// PHW_NOUSE
Property PHWNOUSE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHW_NOUSE ];

/// PHW_MIXFLAG
Property PHWMIXFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHW_MIXFLAG ];

/// PHW_Code
Property PHWCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHW_Code ];

/// PHW_PHP_PYDR
Property PHWPHPPYDR As User.DHCPHPERSON [ SqlColumnNumber = 8, SqlFieldName = PHW_PHP_PYDR ];

/// PHW_PHP_FYDR
Property PHWPHPFYDR As User.DHCPHPERSON [ SqlColumnNumber = 9, SqlFieldName = PHW_PHP_FYDR ];

/// PHW_DOFLAG
Property PHWDOFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHW_DOFLAG ];

/// PHW_Type
Property PHWType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHW_Type ];

/// PHW_DefPyIp
Property PHWDefPyIp As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHW_DefPyIp ];

/// PHW_PrinterName
Property PHWPrinterName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHW_PrinterName ];

/// PHW_DefDspIp
Property PHWDefDspIp As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHW_DefDspIp ];

/// 摆药位置个数
Property PHWPositionNum As %Integer [ SqlColumnNumber = 15, SqlFieldName = PHW_PositionNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHWIN)</SqlIdExpression>
<SQLMap name="PHWMASTER">
<Data name="PHW_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHW_DESC">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHW_DOFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHW_DefDspIp">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHW_DefPyIp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHW_MIXFLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHW_NOUSE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHW_OK">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHW_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHW_PHP_FYDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHW_PHP_PYDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHW_PositionNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHW_PrinterName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHW_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPHWIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHW_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHW_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phwinDesc">
<Global>^DHCPHWINi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHW_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WINDesc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PHW_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHW_DESC})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHW_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phwindex">
<Global>^DHCPHWINi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHW_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHW_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHW_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phwindexphl">
<Global>^DHCPHWINi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHW_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHW_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHW_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWINDOWS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHWIN)
	s oldI = +$g(^mdata("DHCPHWINDOW"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHWIN = maxI
	s ^mdata("DHCPHWINDOW") = maxI
}

}
