/// Voice Call Log
Class User.DHCVISVoiceLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_LogID, SqlTableName = DHC_VIS_VoiceLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Voice Call Content
Property VISVoiceContent As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_VoiceContent ];

/// Client RowID
Property VISClientID As User.DHCVISVoiceClient [ SqlColumnNumber = 3, SqlFieldName = VIS_ClientID ];

/// Server RowID
Property VISServerID As User.DHCVISVoiceServer [ SqlColumnNumber = 4, SqlFieldName = VIS_ServerID ];

/// Log Update Date
Property VISUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = VIS_UpdateDate ];

/// Log Update Time
Property VISUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = VIS_UpdateTime ];

/// Voice Call Queue RowID
Property VISQueueID As User.DHCVISVoiceQueue [ SqlColumnNumber = 7, SqlFieldName = VIS_QueueID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_ClientID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_QueueID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_ServerID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_VoiceContent">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCVISLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_LogID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_LogID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateTimeServer">
<Global>^DHCVISLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VIS_LogID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTimeServer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_UpdateTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_LogID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexQueue">
<Global>^DHCVISLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_LogID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Queue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_LogID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerDate">
<Global>^DHCVISLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VIS_LogID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_LogID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
