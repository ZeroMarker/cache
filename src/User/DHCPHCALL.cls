Class User.DHCPHCALL Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCA_ROWID, SqlTableName = DHC_PHCALL, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCA_CALCS
Property PHCACALCS As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHCA_CALCS ];

/// PHCA_CLFLAG
Property PHCACLFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHCA_CLFLAG ];

/// PHCA_DATE
Property PHCADATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHCA_DATE ];

/// PHCA_PYFLAG
Property PHCAFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHCA_FYFLAG ];

/// PHCA_LEDCS
Property PHCALEDCS As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHCA_LEDCS ];

/// PHCA_PHD_DR
Property PHCAPHDDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCA_PHD_DR ];

/// PHCA_PHL_DR
Property PHCAPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PHCA_PHL_DR ];

/// PHCA_PHW_DR
Property PHCAPHWDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHCA_PHW_DR ];

/// PHCA_SENDFLAG
Property PHCASENDFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHCA_SENDFLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCALL)</SqlIdExpression>
<SQLMap name="PHCAMASTER">
<Data name="PHCA_CALCS">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCA_CLFLAG">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCA_DATE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCA_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHCA_LEDCS">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCA_PHD_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCA_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCA_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCA_SENDFLAG">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHCALL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCA_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PHCAPHLindex">
<Global>^DHCPHCALLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHCA_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHCAPHWi">
<Global>^DHCPHCALLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCA_PHW_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHCA_DATE}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCALLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
