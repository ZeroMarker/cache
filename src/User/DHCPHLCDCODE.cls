/// LCDSERIALNO
Class User.DHCPHLCDCODE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLDC_ROWID, SqlTableName = DHC_PHLCDCODE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHLDC_DATE
Property PHLDCDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHLDC_DATE ];

/// PHLDC_PHL_DR
Property PHLDCPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHLDC_PHL_DR ];

/// PHLDC_PHW_DR
Property PHLDCPHWDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHLDC_PHW_DR ];

/// PHLDC_SERIALNO
Property PHLDCSERIALNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHLDC_SERIALNO ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLDC)</SqlIdExpression>
<SQLMap name="PHLDCINDEX">
<Global>^DHCPHLDCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLDC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHLDC_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHLDC_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHLDC_PHW_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHLDC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dhcphlcdcodemaster">
<Data name="PHLDC_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLDC_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLDC_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLDC_SERIALNO">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHLDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLDC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHLDC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLCDCODES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
