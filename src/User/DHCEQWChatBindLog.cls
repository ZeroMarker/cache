Class User.DHCEQWChatBindLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WCB_RowID, SqlTableName = DHC_EQWChatBindLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WCB_ChatID
Property WCBChatID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WCB_ChatID ];

/// WCB_UserDR
Property WCBUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WCB_UserDR ];

/// WCB_GroupDR
Property WCBGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WCB_GroupDR ];

/// WCB_LocDR
Property WCBLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WCB_LocDR ];

/// WCB_LogDate
Property WCBLogDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WCB_LogDate ];

/// WCB_LogTime
Property WCBLogTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WCB_LogTime ];

/// WCB_BindType
Property WCBBindType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = WCB_BindType ];

/// WCB_AccessType
Property WCBAccessType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WCB_AccessType ];

/// WCB_Hold1
Property WCBHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WCB_Hold1 ];

/// WCB_Hold2
Property WCBHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WCB_Hold2 ];

/// WCB_Hold3
Property WCBHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WCB_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWChatBindLog("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WCB_AccessType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WCB_BindType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WCB_ChatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WCB_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WCB_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WCB_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WCB_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WCB_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WCB_LogDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WCB_LogTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WCB_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQWChatBindLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WCB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WCB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChat">
<Global>^DHCEQWChatBindLog</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Chat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCB_ChatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEQWChatBindLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WCB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCB_UserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWChatBindLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
