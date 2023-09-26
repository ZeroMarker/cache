Class User.DHCPHMANAGE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMA_ROWID, SqlTableName = DHC_PHMANAGE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMA_CTUOM_DR
Property PHMACTUOMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PHMA_CTUOM_DR ];

/// PHMA_DATE
Property PHMADATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHMA_DATE ];

/// PHMA_INCI_DR
Property PHMAINCIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHMA_INCI_DR ];

/// PHMA_PHL_DR
Property PHMAPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHMA_PHL_DR ];

/// PHMA_PHP_DR
Property PHMAPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHMA_PHP_DR ];

/// PHMA_QTY
Property PHMAQTY As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHMA_QTY ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMA)</SqlIdExpression>
<SQLMap name="PHMAMASTER">
<Data name="PHMA_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMA_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMA_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMA_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMA_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMA_QTY">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHMA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMA_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phmaindex">
<Global>^DHCPHMAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHMA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMA_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHMA_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHMA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMANAGES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
