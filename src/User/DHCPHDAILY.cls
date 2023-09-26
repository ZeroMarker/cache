Class User.DHCPHDAILY Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDA_ROWID, SqlTableName = DHC_PHDAILY, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHDA_DATE
Property PHDADATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHDA_DATE ];

/// PHDA_FYJE
Property PHDAFYJE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHDA_FYJE ];

/// PHDA_FYRC
Property PHDAFYRC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHDA_FYRC ];

/// PHDA_PHL_DR
Property PHDAPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PHDA_PHL_DR ];

/// PHDA_PHP_DR
Property PHDAPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHDA_PHP_DR ];

/// PHDA_PYJE
Property PHDAPYJE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHDA_PYJE ];

/// PHDA_PYRC
Property PHDAPYRC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHDA_PYRC ];

/// PHDA_QRFLAG
Property PHDAQRFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHDA_QRFLAG ];

/// PHDA_SocialStatus_DR
Property PHDASocialStatusDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PHDA_SocialStatus_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHDAIL)</SqlIdExpression>
<SQLMap name="PHDAILYMASTER">
<Data name="PHDA_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDA_FYJE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDA_FYRC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDA_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDA_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDA_PYJE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDA_PYRC">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDA_QRFLAG">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDA_SocialStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHDAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHDA_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phdailyindex">
<Global>^DHCPHDAILYi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHDA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHDA_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHDA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDAILYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
