Class User.DHCEQWChatAccessRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WCAR_RowID, SqlTableName = DHC_EQWChatAccessRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WCAR_ChatID
Property WCARChatID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WCAR_ChatID ];

/// WCAR_UserDR
Property WCARUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WCAR_UserDR ];

/// WCAR_AccessType
Property WCARAccessType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WCAR_AccessType ];

/// WCAR_Result
Property WCARResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WCAR_Result ];

/// WCAR_AccessDate
Property WCARAccessDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WCAR_AccessDate ];

/// WCAR_AccessTime
Property WCARAccessTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WCAR_AccessTime ];

/// WCAR_OutDate
Property WCAROutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = WCAR_OutDate ];

/// WCAR_OutTime
Property WCAROutTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = WCAR_OutTime ];

/// WCAR_ActiveFlag
Property WCARActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = WCAR_ActiveFlag ];

/// WCAR_Mac
Property WCARMac As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WCAR_Mac ];

/// WCAR_IP
Property WCARIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WCAR_IP ];

/// WCAR_Hold1
Property WCARHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = WCAR_Hold1 ];

/// WCAR_Hold2
Property WCARHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = WCAR_Hold2 ];

/// WCAR_Hold3
Property WCARHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = WCAR_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWChatAccessRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WCAR_AccessDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WCAR_AccessTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WCAR_AccessType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WCAR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WCAR_ChatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WCAR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WCAR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WCAR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WCAR_IP">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WCAR_Mac">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WCAR_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WCAR_OutTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WCAR_Result">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WCAR_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQWChatAccessRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WCAR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WCAR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeUser">
<Global>^DHCEQWChatAccessRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WCAR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WCAR_AccessType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WCAR_UserDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WCAR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWChatAccessRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
