Class User.DHCPHMONTH Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHM_ROWID, SqlTableName = DHC_PHMONTH, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHM_FYJE
Property PHMFYJE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHM_FYJE ];

/// PHM_FYRC
Property PHMFYRC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHM_FYRC ];

/// PHM_MONTH
Property PHMMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHM_MONTH ];

/// PHM_PHL_DR
Property PHMPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PHM_PHL_DR ];

/// PHM_PHP_DR
Property PHMPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHM_PHP_DR ];

/// PHM_PYJE
Property PHMPYJE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHM_PYJE ];

/// PHM_PYRC
Property PHMPYRC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHM_PYRC ];

/// TPHM_QRFLAG
Property PHMQRFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHM_QRFLAG ];

/// PHM_SocialStatus_DR
Property PHMSocialStatusDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PHM_SocialStatus_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMON)</SqlIdExpression>
<SQLMap name="PHMONTHMASTER">
<Data name="PHM_FYJE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHM_FYRC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHM_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHM_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHM_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHM_PYJE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHM_PYRC">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHM_QRFLAG">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHM_SocialStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHMON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHM_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHM_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMONTHS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
