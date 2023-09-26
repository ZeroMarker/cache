/// Voice Call Client
Class User.DHCVISVoiceClient Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_ClientID, SqlTableName = DHC_VIS_VoiceClient, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Voice Call Client IP
Property VISClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_ClientIP ];

/// Voice Call Client Name
Property VISClientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_ClientName ];

/// Voice Call Client Client Room
Property VISClientLinkRoom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VIS_ClientLinkRoom ];

/// Voice Call ServerID 
Property VISClientServerID As User.DHCVISVoiceServer [ SqlColumnNumber = 5, SqlFieldName = VIS_ClientServerID ];

/// Client Link Doctor ID
Property VISClientLinkDoc As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = VIS_ClientLinkDoc ];

/// Client Update UserID
Property VISClientUpdateUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = VIS_ClientUpdateUser ];

/// Client Update Date
Property VISClientUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = VIS_ClientUpdateDate ];

/// Client Update Time
Property VISClientUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = VIS_ClientUpdateTime ];

/// Client Note
Property VISClientNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = VIS_ClientNote ];

/// Voice Call Client Port No
Property VISClientPortNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = VIS_ClientPortNo ];

/// Client Screen No
Property VISClientScreenNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = VIS_ClientScreenNo ];

/// Client Screen Color No
Property VISClientScreenColorNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = VIS_ClientScreenColorNo ];

/// Show Mode
Property VISClientShowMode As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = VIS_ClientShowMode ];

/// Show Speed
Property VISClientShowSpeed As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = VIS_ClientShowSpeed ];

/// Show Time
Property VISClientShowTime As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = VIS_ClientShowTime ];

/// SetTopIP
Property VISClientTopIP As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = VIS_ClientTopIP ];

/// SetTopDesc
Property VISClientTopDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = VIS_ClientTopDesc ];

/// Loc SetTop IP
Property VISLocTopIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = VIS_LocTopIP ];

/// Loc SetTop Note
Property VISLocTopDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = VIS_LocTopDesc ];

/// Client Voice SetTop IP
Property VISClientVoiceTopIP As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = VIS_ClientVoiceTopIP ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISClient)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_ClientIP">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_ClientLinkDoc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VIS_ClientLinkRoom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VIS_ClientName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_ClientNote">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VIS_ClientPortNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIS_ClientScreenColorNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_ClientScreenNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_ClientServerID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_ClientShowMode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VIS_ClientShowSpeed">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VIS_ClientShowTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VIS_ClientTopDesc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="VIS_ClientTopIP">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="VIS_ClientUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="VIS_ClientUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="VIS_ClientUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VIS_ClientVoiceTopIP">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="VIS_LocTopDesc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="VIS_LocTopIP">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCVISClient</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClientIP">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClientName">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClientTopIP">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientTopIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientTopIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExaRoom">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExaRoomId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientLinkRoom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkDoc">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientLinkDoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTopIP">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocTopIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_LocTopIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerID">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientServerID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerLocTop">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SeverLocTop"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientServerID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_LocTopIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerTop">
<Global>^DHCVISClienti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VIS_ClientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerTop"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientServerID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ClientTopIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceClientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
