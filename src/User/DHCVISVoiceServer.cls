/// Voice Call Server
Class User.DHCVISVoiceServer Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_ServerID, SqlTableName = DHC_VIS_VoiceServer, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Voice Call Server IP
Property VISServerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_ServerIP ];

/// Voice Server Name
Property VISServerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_ServerName ];

/// Voice Call Server Link LocID
Property VISServerLinkLoc As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = VIS_ServerLinkLoc ];

/// Voice Call Server Link Other Loc ID
Property VISServerLinkOtherLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VIS_ServerLinkOtherLoc ];

/// Voice Call Note
Property VISServerNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VIS_ServerNote ];

/// Voice Call Server Active
Property VISServerActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = VIS_ServerActive ];

/// Voice Call Server Update Date
Property VISServerUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = VIS_ServerUpdateDate ];

/// Voice Call Server Update Time
Property VISServerUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = VIS_ServerUpdateTime ];

/// Voice Call Server Update User ID
Property VISServerUpdateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = VIS_ServerUpdateUser ];

/// Server Port No
Property VISServerPortNo As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = VIS_ServerPortNo ];

/// Server Screen No
Property VISServerScreenNo As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = VIS_ServerScreenNo ];

/// Server Screen Color No
Property VISServerScreenColorNo As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = VIS_ServerScreenColorNo ];

/// ServerTopIP
Property VISServerTopIP As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = VIS_ServerTopIP ];

/// ServerTopDesc
Property VISServerTopDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = VIS_ServerTopDesc ];

/// Server Voice TopIP
Property VISServerVoiceTopIP As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = VIS_ServerVoiceTopIP ];

/// Super Server Voice
Property VISServerSuper As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = VIS_ServerSuper ];

/// Auto Update Falge
Property VISServerAutoUpdate As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = VIS_ServerAutoUpdate ];

/// 要显示的通知消息
Property VISNotification As %Library.String [ SqlColumnNumber = 19, SqlFieldName = VIS_Notification ];

/// 是否显示等候病人列表
Property VISWaitPaitList As %Library.String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = VIS_WaitPaitList ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISServer)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_Notification">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="VIS_ServerActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_ServerAutoUpdate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="VIS_ServerIP">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_ServerLinkLoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VIS_ServerLinkOtherLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VIS_ServerName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_ServerNote">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VIS_ServerPortNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIS_ServerScreenColorNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_ServerScreenNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_ServerSuper">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="VIS_ServerTopDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="VIS_ServerTopIP">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VIS_ServerUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VIS_ServerUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VIS_ServerUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VIS_ServerVoiceTopIP">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="VIS_WaitPaitList">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCVISServer</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_ServerID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBor">
<Global>^DHCVISServeri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ServerID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkBor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerLinkLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkLoc">
<Global>^DHCVISServeri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ServerID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerLinkOtherLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerIP">
<Global>^DHCVISServeri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ServerID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerName">
<Global>^DHCVISServeri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_ServerID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceServerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
