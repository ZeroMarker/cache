Class User.DHCPHUNDREAS Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUNDR_ROWID, SqlTableName = DHC_PHUNDREAS, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHUNDR_DESC
Property PHUNDRDESC As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHUNDR_DESC ];

/// PHUNDR_TYPE
Property PHUNDRTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHUNDR_TYPE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHUNDR)</SqlIdExpression>
<SQLMap name="PHUNDRMASTER">
<Data name="PHUNDR_DESC">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUNDR_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHUNDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHUNDR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUNDR_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNDREASS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
