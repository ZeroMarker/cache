Class User.DHCPHDREPRINT Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDR_ROWID, SqlTableName = DHC_PHDREPRINT, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHDR_DATE
Property PHDRDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHDR_DATE ];

/// PHDR_PHP_DR
Property PHDRPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHDR_PHP_DR ];

/// PHDR_PHD_DR
Property PHDRPOINTER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHDR_POINTER ];

/// PHDR_TIME
Property PHDRTIME As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHDR_TIME ];

/// PHDR_TYPE
Property PHDRTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHDR_TYPE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHDR)</SqlIdExpression>
<SQLMap name="PHDRINDEX">
<Global>^DHCPHDRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PERSON"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHDR_PHP_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHDR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHDRMASTER">
<Data name="PHDR_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDR_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDR_POINTER">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDR_TIME">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDR_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHDR_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDREPRINTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
