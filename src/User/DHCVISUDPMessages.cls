Class User.DHCVISUDPMessages Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_UDPMessages, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Message Session ID
Property SessionID As %Library.Float [ SqlColumnNumber = 2 ];

/// Message Content
Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Message State
Property State As %Library.String(DISPLAYLIST = ",S,I,F,N", MAXLEN = 1, SELECTIVITY = "20.0000%", VALUELIST = ",Success,Invalid,Failure,New") [ SqlColumnNumber = 4 ];

/// Remote IP
Property RemoteIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Server ID
Property ServerID As User.DHCVISVoiceServer [ SqlColumnNumber = 6 ];

/// Create Date
Property CreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7 ];

/// Create Time
Property CreateTime As %Library.Time [ SqlColumnNumber = 8 ];

/// Expand Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISUDPM)</SqlIdExpression>
<SQLMap name="IndexDateRemoteIPState">
<Global>^DHCVISUDPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateRemoteIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RemoteIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{State}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateServerState">
<Global>^DHCVISUDPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateServerState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ServerID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{State}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateSession">
<Global>^DHCVISUDPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateSession"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SessionID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateState">
<Global>^DHCVISUDPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{State}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="Content">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RemoteIP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ServerID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SessionID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="State">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCVISUDPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISUDPMessagesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
