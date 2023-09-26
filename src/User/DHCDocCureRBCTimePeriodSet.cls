Class User.DHCDocCureRBCTimePeriodSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDCTS_Rowid, SqlTableName = DHC_DocCureRBCTimePeriodSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDCTS_Code
Property DDCTSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DDCTS_Code ];

/// DDCTS_Desc
Property DDCTSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DDCTS_Desc ];

/// DDCTS_StartTime
Property DDCTSStartTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DDCTS_StartTime ];

/// DDCTS_EndTime
Property DDCTSEndTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DDCTS_EndTime ];

/// DDCTS_EndChargeTime
Property DDCTSEndChargeTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DDCTS_EndChargeTime ];

/// DDCTS_NotAvailFlag
Property DDCTSNotAvailFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DDCTS_NotAvailFlag ];

/// DDCTS_EndChargeTime
Property DDCTSEndAppointTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DDCTS_EndAppointTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureRBCTimePeriodSet)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCDocCureRBCTimePeriodSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCTS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCTS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCTS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DDCTS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCTS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCTS_EndAppointTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCTS_EndChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCTS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCTS_NotAvailFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCTS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureRBCTimePeriodSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCTS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DDCTS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTimePeriodSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
