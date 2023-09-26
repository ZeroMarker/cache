Class User.DHCPHSERIAL Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHS_ROWID, SqlTableName = DHC_PHSERIAL, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHS_FYFLAG
Property PHSFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHS_FYFLAG ];

/// PHS_MONTH
Property PHSMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHS_MONTH ];

/// PHS_PHL_DR
Property PHSPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHS_PHL_DR ];

/// PHS_SERIALNO
Property PHSSERIALNO As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHS_SERIALNO ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHSERIAL)</SqlIdExpression>
<SQLMap name="PHSERIALINDEX">
<Global>^DHCPHSERIALi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHS_MONTH}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHS_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHS_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHSMASTER">
<Data name="PHS_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHS_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHS_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHS_SERIALNO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHSERIAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHS_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSERIALS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
