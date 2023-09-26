Class User.DHCEQWChatUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WCU_RowID, SqlTableName = DHC_EQWChatUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WCU_ChatID
Property WCUChatID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WCU_ChatID ];

/// WCU_UserDR
Property WCUUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WCU_UserDR ];

/// WCU_GroupDR
Property WCUGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WCU_GroupDR ];

/// WCU_LocDR
Property WCULocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WCU_LocDR ];

/// WCU_Date
Property WCUDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WCU_Date ];

/// WCU_Time
Property WCUTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WCU_Time ];

/// WCU_BindCount
Property WCUBindCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = WCU_BindCount ];

/// WCU_Password
Property WCUPassword As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WCU_Password ];

/// WCU_AccessType
Property WCUAccessType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WCU_AccessType ];

/// WCU_UserTel
Property WCUUserTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WCU_UserTel ];

/// WCU_Hold1
Property WCUHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WCU_Hold1 ];

/// WCU_Hold2
Property WCUHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = WCU_Hold2 ];

/// WCU_Hold3
Property WCUHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = WCU_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWChatUser("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WCU_AccessType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WCU_BindCount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WCU_ChatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WCU_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WCU_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WCU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WCU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WCU_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WCU_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WCU_Password">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WCU_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WCU_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WCU_UserTel">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQWChatUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WCU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WCU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEQWChatUser</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WCU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCU_UserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWChat">
<Global>^DHCEQWChatUser</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WCU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WChat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCU_ChatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWChatUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
