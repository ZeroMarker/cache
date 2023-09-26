Class User.DHCPHPATIENCODE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPAT_ROWID, SqlTableName = DHCPHPATIENCODE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property PHPATCODE As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHPAT_CODE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHPATCODE)</SqlIdExpression>
<SQLMap name="PHPATCODEMASTER">
<Data name="PHPAT_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHPATCODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPAT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHPAT_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPATIENCODES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
