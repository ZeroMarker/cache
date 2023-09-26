Class User.DHCRBCLINICRPTCONNECTDOC Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRCD_RowID, SqlTableName = DHCRB_CLINICRPTCONNECTDOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRCD_ClinicCheckInfoRowid
Property DRCDClinicCheckInfoRowid As User.DHCRBCLINICCHECKRPTINFO [ SqlColumnNumber = 2, SqlFieldName = DRCD_ClinicCheckInfoRowid ];

/// Clinic Doctor Code 
Property DRCDDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRCD_DocCode ];

/// the checked status of the report
Property DRCDIsChecked As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRCD_IsChecked ];

/// the modify status of the report
Property DRCDIsModify As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRCD_IsModify ];

/// Checked Date
Property DRCDCheckedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DRCD_CheckedDate ];

/// Checked Time
Property DRCDCheckedTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DRCD_CheckedTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLINICRPTCONNECTDOC)</SqlIdExpression>
<SQLMap name="IndexReportToDoctor">
<Data name="DRCD_IsChecked">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRCD_IsModify">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCLINICRPTCONNECTDOCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRCD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRCD_ClinicCheckInfoRowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCD_DocCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRCD_CheckedDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRCD_CheckedTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRCD_ClinicCheckInfoRowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRCD_DocCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRCD_IsChecked">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRCD_IsModify">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCLINICRPTCONNECTDOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRCD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRCD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLINICRPTCONNECTDOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
