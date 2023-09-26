Class User.DHCPHPLOC Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPL_ROWID, SqlTableName = DHC_PHPLOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHPL_PHL_DR
Property PHPLPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHPL_PHL_DR ];

/// PHPL_PHP_DR
Property PHPLPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHPL_PHP_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPL)</SqlIdExpression>
<SQLMap name="PHPLMASTER">
<Data name="PHPL_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPL_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHPL_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPLOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
