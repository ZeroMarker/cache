Class User.DHCPHWINQUEUE Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWQU_ROWID, SqlTableName = DHC_PHWINQUEUE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHWQU_Date
Property PHWQUDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHWQU_Date ];

/// PHWQU_Time
Property PHWQUTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHWQU_Time ];

/// PHWQU_Ctloc_DR
Property PHWQUCtlocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHWQU_Ctloc_DR ];

/// PHWQU_No
Property PHWQUNo As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHWQU_No ];

/// PHWQU_Status
Property PHWQUStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHWQU_Status ];

/// PHWQU_Count
Property PHWQUCount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHWQU_Count ];

/// PHWQU_Window_DR
Property PHWQUWindowDR As User.DHCPHWINDOW [ SqlColumnNumber = 8, SqlFieldName = PHWQU_Window_DR ];

/// PHWQU_PAPMI_DR
Property PHWQUPAPMIDR As User.PAPatMas [ SqlColumnNumber = 9, SqlFieldName = PHWQU_PAPMI_DR ];

/// PHWQU_Prefix
Property PHWQUPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHWQU_Prefix ];

/// 排号状态
Property PHWQUQueState As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHWQU_QueState ];

/// 报到操作人
Property PHWQUUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = PHWQU_User_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHWQU)</SqlIdExpression>
<SQLMap name="IndexCTLoc">
<Global>^DHCPHWQUi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWQU_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Ctloc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Prefix}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHWQU_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCPHWQUi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWQU_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Ctloc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHWQU_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHWQU_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPHWQUi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHWQU_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Ctloc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Prefix}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHWQU_Status}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PHWQU_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCPHWQU">
<Data name="PHWQU_Count">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHWQU_Ctloc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHWQU_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHWQU_No">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHWQU_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHWQU_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHWQU_QueState">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHWQU_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHWQU_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHWQU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHWQU_Window_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHWQU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHWQU_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHWQU_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWINQUEUES</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHWQU)
	s oldI = +$g(^mdata("DHCPHWINQUEUE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHWQU = maxI
	s ^mdata("DHCPHWINQUEUE") = maxI
}

}
