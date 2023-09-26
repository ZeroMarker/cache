Class User.DHCPHSKSCREEN Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSK_ROWID, SqlTableName = DHC_PHSKSCREEN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHSK_DATE
Property PHSKDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHSK_DATE ];

Property PHSKPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHSK_PAADM_DR ];

/// PHSK_PHL_DR
Property PHSKPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHSK_PHL_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHSK)</SqlIdExpression>
<SQLMap name="PHSKINDEX">
<Global>^PHSKi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHSK_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHSK_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHSK_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSK_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHSKMASTER">
<Data name="PHSK_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSK_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSK_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHSK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSK_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHSK_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSKSCREENS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
