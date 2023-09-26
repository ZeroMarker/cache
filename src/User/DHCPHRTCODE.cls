Class User.DHCPHRTCODE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHRTC_ROWID, SqlTableName = DHC_PHRTCODE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHRTC_CODE
Property PHRTCCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHRTC_CODE ];

/// PHRTC_MONTH
Property PHRTCMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHRTC_MONTH ];

/// PHRTC_PHL_DR
Property PHRTCPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHRTC_PHL_DR ];

/// PHRTC_TYFLAG
Property PHRTCTYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHRTC_TYFLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHRTC)</SqlIdExpression>
<SQLMap name="PHRTCINDEX">
<Global>^DHCPHRTCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHRTC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRTC_MONTH}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRTC_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRTC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRTCMASTER">
<Data name="PHRTC_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRTC_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHRTC_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHRTC_TYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHRTC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHRTC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRTC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHRTCODES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
