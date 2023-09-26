Class User.DHCPHIDISPEN Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHID_ROWID, SqlTableName = DHC_PHIDISPEN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHIDISPSUB As User.DHCPHIDISPSUB [ Cardinality = children, Inverse = PHIDSPHIDPARREF ];

/// PHID_DATE
Property PHIDDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHID_DATE ];

/// PHID_FYFLAG
Property PHIDFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHID_FYFLAG ];

/// PHID_PAADM_DR
Property PHIDPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHID_PAADM_DR ];

/// PHID_PHL_DR
Property PHIDPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PHID_PHL_DR ];

/// PHID_PHP_FYDR
Property PHIDPHPFYDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHID_PHP_FYDR ];

/// PHID_PHP_PYDR
Property PHIDPHPPYDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHID_PHP_PYDR ];

/// PHID_PHW_DR
Property PHIDPHWDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PHID_PHW_DR ];

/// PHID_PYFLAG
Property PHIDPYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHID_PYFLAG ];

/// PHID_SERIALNO
Property PHIDSERIALNO As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHID_SERIALNO ];

/// PHID_TIME
Property PHIDTIME As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PHID_TIME ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHID)</SqlIdExpression>
<SQLMap name="PHIDINDEX">
<Global>^DHCPHIDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHID_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHID_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHID_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHIDISPENMASTER">
<Data name="PHID_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHID_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHID_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHID_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHID_PHP_FYDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHID_PHP_PYDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHID_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHID_PYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHID_SERIALNO">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHID_TIME">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHID</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHID_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHID_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHIDISPENS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
