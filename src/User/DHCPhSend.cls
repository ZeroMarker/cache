Class User.DHCPhSend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHS_Rowid, SqlTableName = DHC_PhSend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHS_Inci_dr
Property PHSIncidr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = PHS_Inci_dr ];

/// PHS_ctloc_dr
Property PHSctlocdr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHS_ctloc_dr ];

/// PHS_SendFlag
Property PHSSendFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHS_SendFlag ];

/// PHS_Add1
Property PHSAdd1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHS_Add1 ];

/// PHS_Add2
Property PHSAdd2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHS_Add2 ];

/// PHS_QTY
Property PHSQTY As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHS_QTY ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHSEND)</SqlIdExpression>
<SQLMap name="DHCPHSendmaster">
<Data name="PHS_Add1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHS_Add2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHS_Inci_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHS_QTY">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHS_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHS_ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHSEND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="dhcphsendindex">
<Global>^DHCPHSENDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHS_Inci_dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhSendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHSEND)
	s oldI = +$g(^mdata("DHCPHSEND"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHSEND = maxI
	s ^mdata("DHCPHSEND") = maxI
}

}
