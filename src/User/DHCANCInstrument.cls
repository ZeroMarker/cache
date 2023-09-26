/// DHC_ANC_Instrument
Class User.DHCANCInstrument Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCINSTR_RowId, SqlTableName = DHC_ANC_Instrument, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCINSTR_Code
Property ANCINSTRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCINSTR_Code ];

/// ANCINSTR_Desc
Property ANCINSTRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCINSTR_Desc ];

Index ANCINSTRCodeUnqIdx1 On ANCINSTRCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("Instrument",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCINSTR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCINSTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCINSTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Instrument"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCINSTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCInstrumentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
