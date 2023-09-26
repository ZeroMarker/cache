Class User.DHCPHOweList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHO_RowID, SqlTableName = DHC_PHOweList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHOweListItm As User.DHCPHOweListItm [ Cardinality = children, Inverse = PHOIPHOPARREF ];

/// PHO_No
Property PHONo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHO_No ];

/// PHO_Loc_Dr
Property PHOLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHO_Loc_Dr ];

/// PHO_Date
Property PHODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHO_Date ];

/// PHO_Time
Property PHOTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHO_Time ];

/// PHO_User_Dr
Property PHOUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PHO_User_Dr ];

/// PHO_PrescNo
Property PHOPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHO_PrescNo ];

/// PHO_PRT_Dr
Property PHOPrtDr As User.DHCINVPRT [ SqlColumnNumber = 8, SqlFieldName = PHO_Prt_Dr ];

/// PHO_Status
Property PHOStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHO_Status ];

/// PHO_Papmi
Property PHOPapmiDr As User.PAPatMas [ SqlColumnNumber = 10, SqlFieldName = PHO_Papmi_Dr ];

/// PHO_RetDate
Property PHORetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PHO_RetDate ];

/// PHO_RetTime
Property PHORetTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PHO_RetTime ];

/// PHO_RetUser
Property PHORetUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PHO_RetUser_Dr ];

/// PHO_RetPrt_Dr
Property PHORetPrtDr As User.DHCINVPRT [ SqlColumnNumber = 14, SqlFieldName = PHO_RetPrt_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHOW)</SqlIdExpression>
<SQLMap name="IndexDateLoc">
<Global>^DHCPHOWi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHO_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHO_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLOC">
<Global>^DHCPHOWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHO_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHO_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHOWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHO_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHO_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrt">
<Global>^DHCPHOWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHO_Prt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCPHOW">
<Data name="PHO_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHO_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHO_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHO_Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHO_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHO_Prt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHO_RetDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHO_RetPrt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHO_RetTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHO_RetUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHO_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHO_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHO_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHOW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHOweListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHOW)
	s oldI = +$g(^mdata("DHCPHOWELIST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHOW = maxI
	s ^mdata("DHCPHOWELIST") = maxI
}

}
