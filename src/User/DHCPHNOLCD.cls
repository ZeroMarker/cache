Class User.DHCPHNOLCD Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHNL_ROWID, SqlTableName = DHC_PHNOLCD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHNL_DATE
Property PHNLDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHNL_DATE ];

/// PHNL_PAPMINO
Property PHNLPAPMINO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHNL_PAPMINO ];

/// PHNL_PERNAME
Property PHNLPERNAME As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHNL_PERNAME ];

/// PHNL_PHD_DR
Property PHNLPHDDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHNL_PHD_DR ];

/// PHNL_PHL_DR
Property PHNLPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHNL_PHL_DR ];

/// PHNL_PHW_DR
Property PHNLPHWDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PHNL_PHW_DR ];

/// PHNL_PYTIME
Property PHNLPYTIME As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PHNL_PYTIME ];

/// PHNL_XSFLAG
Property PHNLXSFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHNL_XSFLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHNL)</SqlIdExpression>
<SQLMap name="PHNLINDEX">
<Global>^DHCPHNLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHNL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHNL_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHNL_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHNL_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHNLMASTER">
<Data name="PHNL_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHNL_PAPMINO">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHNL_PERNAME">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHNL_PHD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHNL_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHNL_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHNL_PYTIME">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHNL_XSFLAG">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHNL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHNL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHNL_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHNOLCDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
