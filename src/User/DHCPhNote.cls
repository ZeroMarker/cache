Class User.DHCPhNote Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHN_ROWID, SqlTableName = DHC_PhNote, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHN_PAPMI_DR
Property PHNPAPMIDR As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PHN_PAPMI_DR ];

/// PHN_DATE
Property PHNDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHN_DATE ];

/// PHN_TIME
Property PHNTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PHN_TIME ];

/// PHN_SERIALNO
Property PHNSERIALNO As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHN_SERIALNO ];

/// PHN_CANCELFLAG
Property PHNCANCELFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHN_CANCELFLAG ];

/// PHN_PHL_DR
Property PHNPHLDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHN_PHL_DR ];

/// PHN_PHW_DR
Property PHNPHWDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHN_PHW_DR ];

/// PHN_ADDITM1
Property PHNADDITM1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHN_ADDITM1 ];

/// PHN_ADDITM2
Property PHNADDITM2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHN_ADDITM2 ];

/// PHN_ADDITM3
Property PHNADDITM3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHN_ADDITM3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHNOTE)</SqlIdExpression>
<SQLMap name="DHCPHNoteMASTER">
<Data name="PHN_ADDITM1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHN_ADDITM2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHN_ADDITM3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHN_CANCELFLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHN_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHN_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHN_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHN_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHN_SERIALNO">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHN_TIME">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHNOTE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHN_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DHCPHNoteindex">
<Global>^DHCPHNOTEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHN_DATE}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHN_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHN_PHL_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHN_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhNoteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
