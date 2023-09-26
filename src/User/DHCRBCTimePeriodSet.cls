Class User.DHCRBCTimePeriodSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DTPS_Rowid, SqlTableName = DHCRBC_TimePeriodSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DTPS_Code
Property DTPSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DTPS_Code ];

/// DTPS_Desc
Property DTPSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DTPS_Desc ];

/// DTPS_StartTime
Property DTPSStartTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DTPS_StartTime ];

/// DTPS_EndTime
Property DTPSEndTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DTPS_EndTime ];

/// DTPS_EndChargeTime
Property DTPSEndChargeTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DTPS_EndChargeTime ];

/// DTPS_NotAvailable
Property DTPSNotAvailable As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DTPS_NotAvailable ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTimePeriodSet)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCTimePeriodSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DTPS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTPS_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTPS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DTPS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTPS_EndChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DTPS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DTPS_NotAvailable">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DTPS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCTimePeriodSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DTPS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DTPS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTimePeriodSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
