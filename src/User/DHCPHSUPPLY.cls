Class User.DHCPHSUPPLY Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SUPP_RowID, SqlTableName = DHC_PHSUPPLY, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHSUPPLYITM As User.DHCPHSUPPLYITM [ Cardinality = children, Inverse = SUPPIParRef ];

/// SUPP_PHLOC_Dr
Property SUPPPHLOCDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = SUPP_PHLOC_Dr ];

/// SUPP_DATE
Property SUPPDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = SUPP_DATE ];

/// SUPP_TIME
Property SUPPTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = SUPP_TIME ];

/// SUPP_NO
Property SUPPNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SUPP_NO ];

/// SUPP_WARDLOC_Dr
Property SUPPWARDLOCDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = SUPP_WARDLOC_Dr ];

/// SUPP_DOCLOC_Dr
Property SUPPDOCLOCDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = SUPP_DOCLOC_Dr ];

/// SUPP_USER_Dr
Property SUPPUSERDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = SUPP_USER_Dr ];

/// SUPP_TYPE
Property SUPPTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SUPP_TYPE ];

/// SUPP_CompleteFlag 0未完成，1全部完成，2部分完成
Property SUPPCompleteFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SUPP_CompleteFlag ];

Property SUPPDATEBeg As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = SUPP_DATEBeg ];

Property SUPPDATEEnd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = SUPP_DATEEnd ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHSUPP)</SqlIdExpression>
<SQLMap name="IndexDOCLOC">
<Global>^DHCPHSUPPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SUPP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DOCLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SUPP_PHLOC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SUPP_DATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SUPP_TYPE}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SUPP_DOCLOC_Dr}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{SUPP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWARDLOC">
<Global>^DHCPHSUPPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SUPP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"WARDLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SUPP_PHLOC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SUPP_DATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SUPP_TYPE}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SUPP_WARDLOC_Dr}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{SUPP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDATA">
<Data name="SUPP_CompleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUPP_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUPP_DATEBeg">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUPP_DATEEnd">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUPP_DOCLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUPP_NO">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUPP_PHLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUPP_TIME">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUPP_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUPP_USER_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUPP_WARDLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHSUPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SUPP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SUPP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSUPPLYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHSUPP)
	s oldI = +$g(^mdata("DHCPHSUPPLY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHSUPP = maxI
	s ^mdata("DHCPHSUPPLY") = maxI
}

}
