Class User.DHCPhSendMsg Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSM_ROWID, SqlTableName = DHC_PhSendMsg, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHSENDMSGITM As User.DHCPHSENDMSGITM [ Cardinality = children, Inverse = PHSMIPHSMParref ];

/// PHSM_DATE
Property PHSMDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHSM_DATE ];

/// PHSM_TIME
Property PHSMTIME As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHSM_TIME ];

/// PHSM_PHL_DR
Property PHSMPHLDR As User.DHCPHLOC [ SqlColumnNumber = 4, SqlFieldName = PHSM_PHL_DR ];

/// PHSM_PAPMI_DR
Property PHSMPAPMIDR As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = PHSM_PAPMI_DR ];

/// PHSM_PRESCNO
Property PHSMPRESCNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHSM_PRESCNO ];

/// PHSM_COMMCODE
Property PHSMORDNUM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHSM_ORDNUM ];

/// PHSM_SMFLAG
Property PHSMSMFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHSM_SMFLAG ];

/// PHSM_CLFLAG
Property PHSMCLFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHSM_CLFLAG ];

/// PHSM_RETCODE
Property PHSMRETCODE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHSM_RETCODE ];

/// PHSM_REQNUM
Property PHSMREQNUM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHSM_REQNUM ];

/// PHSM_OUTNUM
Property PHSMOUTNUM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHSM_OUTNUM ];

/// PHSM_ORDSTATE
Property PHSMORDSTATE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHSM_ORDSTATE ];

/// PHSM_ADDITM1
Property PHSMADDITM1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHSM_ADDITM1 ];

/// PHSM_ADDITM2
Property PHSMADDITM2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHSM_ADDITM2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHSM)</SqlIdExpression>
<SQLMap name="PHSMINDEX1">
<Global>^DHCPHSMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSM_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"COMMIT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHSM_ORDNUM}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSM_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHSM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHSMINDEX2">
<Global>^DHCPHSMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSM_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHSM_DATE}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSM_PRESCNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHSM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHSMINDEX3">
<Global>^DHCPHSMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHSM_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHSM_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHSM_REQNUM}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHSMMASTER">
<Data name="PHSM_ADDITM1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHSM_ADDITM2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHSM_CLFLAG">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSM_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSM_ORDNUM">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSM_ORDSTATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHSM_OUTNUM">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHSM_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHSM_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHSM_PRESCNO">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHSM_REQNUM">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHSM_RETCODE">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHSM_SMFLAG">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHSM_TIME">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCPHSM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSM_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHSM_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhSendMsgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHSM)
	s oldI = +$g(^mdata("DHCPHSENDMSG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHSM = maxI
	s ^mdata("DHCPHSENDMSG") = maxI
}

}
