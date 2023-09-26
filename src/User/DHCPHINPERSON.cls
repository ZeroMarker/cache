Class User.DHCPHINPERSON Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHINP_ROWID, SqlTableName = DHC_PHINPERSON, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHINP_AGE
Property PHINPAGE As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PHINP_AGE ];

/// PHINP_DEMO
Property PHINPDEMO As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHINP_DEMO ];

/// PHINP_DOB
Property PHINPDOB As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHINP_DOB ];

/// PHINP_IDCARD
Property PHINPIDCARD As %Library.String(COLLATION = "Exact", MAXLEN = 25, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHINP_IDCARD ];

/// PHINP_NAME
Property PHINPNAME As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHINP_NAME ];

/// PHINP_PATNO
Property PHINPPATNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHINP_PATNO ];

/// PHINP_CODE
Property PHINPPERSONCODE As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHINP_PERSONCODE ];

/// PHINP_SEX_DR
Property PHINPSEXDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = PHINP_SEX_DR ];

/// PHINP_SOCSTATUS_DR  CT_SocialStatus
Property PHINPSOCSTATUSDR As User.CTSocialStatus [ SqlColumnNumber = 6, SqlFieldName = PHINP_SOCSTATUS_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHINP)</SqlIdExpression>
<SQLMap name="PHINPMASTER">
<Data name="PHINP_AGE">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHINP_DEMO">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHINP_DOB">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHINP_IDCARD">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHINP_NAME">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHINP_PATNO">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHINP_PERSONCODE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHINP_SEX_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHINP_SOCSTATUS_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHINP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHINP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHINP_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phinpindex">
<Global>^DHCPHINPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHINP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHINP_NAME}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHINP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHINPERSONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHINP)
	s oldI = +$g(^mdata("DHCPHINPERSON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHINP = maxI
	s ^mdata("DHCPHINPERSON") = maxI
}

}
