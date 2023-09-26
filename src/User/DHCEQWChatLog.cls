Class User.DHCEQWChatLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WCL_RowID, SqlTableName = DHC_EQWChatLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WCL_ChatID
Property WCLChatID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WCL_ChatID ];

/// WCL_UserDR
Property WCLUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WCL_UserDR ];

/// WCL_GroupDR
Property WCLGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WCL_GroupDR ];

/// WCL_LocDR
Property WCLLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WCL_LocDR ];

/// WCL_LogDate
Property WCLLogDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WCL_LogDate ];

/// WCL_LogTime
Property WCLLogTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WCL_LogTime ];

/// WCL_MethodCode
Property WCLMethodCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = WCL_MethodCode ];

/// WCL_Permission
Property WCLPermission As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WCL_Permission ];

/// WCL_AccessType
Property WCLAccessType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WCL_AccessType ];

/// WCL_ClassName
Property WCLClassName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WCL_ClassName ];

/// WCL_MethodName
Property WCLMethodName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WCL_MethodName ];

/// WCL_LogProcess
Property WCLLogProcess As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = WCL_LogProcess ];

/// WCL_Hold1
Property WCLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = WCL_Hold1 ];

/// WCL_Hold2
Property WCLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = WCL_Hold2 ];

/// WCL_Hold3
Property WCLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = WCL_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWChatLog("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WCL_AccessType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WCL_ChatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WCL_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WCL_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WCL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WCL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WCL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WCL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WCL_LogDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WCL_LogProcess">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WCL_LogTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WCL_MethodCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WCL_MethodName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WCL_Permission">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WCL_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQWChatLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WCL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEQWChatLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCL_UserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWChat">
<Global>^DHCEQWChatLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WChat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCL_ChatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWChatLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
