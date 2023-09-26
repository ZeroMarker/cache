/// Voice Cloud Message
Class User.DHCVISVoiceMessage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VoiceID, SqlTableName = DHC_VIS_VoiceMessage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Voice Message Content
Property VoiceContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Voice Message State
Property VoiceState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3 ];

/// Voice Message Plan Date
Property VoicePlanDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4 ];

/// Voice Message Plan Time
Property VoicePlanTime As %Library.Time [ SqlColumnNumber = 5 ];

/// Voice Message Send Remote IP
Property VoiceRemoteIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Send Voice Message IP
Property WarnId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// Insert Voice Message Date
Property InsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8 ];

/// Insert Voice Message Time
Property InsertTime As %Library.Time [ SqlColumnNumber = 9 ];

/// Update Voice Message Server IP
Property UpdateIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// Update Voice Message Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11 ];

/// Update Voice Message Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 12 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISVoice)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UpdateIP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VoiceContent">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VoicePlanDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VoicePlanTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VoiceRemoteIP">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VoiceState">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WarnId">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCVISVoice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VoiceID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VoiceID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPlanDateStateTime">
<Global>^DHCVISVoicei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VoiceID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlanState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VoicePlanDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VoiceState}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VoicePlanTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VoiceID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlanDateWarnId">
<Global>^DHCVISVoicei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VoiceID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WarnId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VoicePlanDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VoiceState}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WarnId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VoiceID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexState">
<Global>^DHCVISVoicei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VoiceID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"State"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VoiceState}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VoiceID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateServerIP">
<Global>^DHCVISVoicei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VoiceID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UpdateIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VoiceID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
