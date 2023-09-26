Class User.DHCIPBillOrdPrintFlag Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ORDP_RowID, SqlTableName = DHC_IPBillOrdPrintFlag, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ORDP_OEORI_DR
Property ORDPOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ORDP_OEORI_DR ];

/// ORDP_PrintDate
Property ORDPPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ORDP_PrintDate ];

/// ORDP_PrintTime
Property ORDPPrintTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ORDP_PrintTime ];

/// ORDP_PrintUser
Property ORDPPrintUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORDP_PrintUser ];

/// ORDP_Comment1
Property ORDPComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ORDP_Comment1 ];

/// ORDP_Comment2
Property ORDPComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ORDP_Comment2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPBILLORDPRINTFLAG)</SqlIdExpression>
<SQLMap name="IndexOEORI">
<Global>^DHCIPBILLORDPRINTFLAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORDP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORDP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORDP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCIPBILLORDPRINT">
<Data name="ORDP_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORDP_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORDP_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORDP_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORDP_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORDP_PrintUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPBILLORDPRINTFLAG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORDP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ORDP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillOrdPrintFlagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
