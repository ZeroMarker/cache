Class User.DHCEQMovePosition Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MP_RowID, SqlTableName = DHC_EQMovePosition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MP_MoveDR
Property MPMoveDR As User.DHCEQMove [ SqlColumnNumber = 2, SqlFieldName = MP_MoveDR ];

/// MP_EventType
Property MPEventType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MP_EventType ];

/// MP_EventProcess
Property MPEventProcess As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MP_EventProcess ];

/// MP_LocationDR
Property MPLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 5, SqlFieldName = MP_LocationDR ];

/// MP_Date
Property MPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MP_Date ];

/// MP_Time
Property MPTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MP_Time ];

/// MP_CreateUserDR
Property MPCreateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MP_CreateUserDR ];

/// MP_CreateDate
Property MPCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MP_CreateDate ];

/// MP_CreateTime
Property MPCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MP_CreateTime ];

/// MP_Remark
Property MPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MP_Remark ];

/// MP_InvalidFlag
Property MPInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MP_InvalidFlag ];

/// MP_InvalidReason
Property MPInvalidReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MP_InvalidReason ];

/// MP_InvalidUserDR
Property MPInvalidUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MP_InvalidUserDR ];

/// MP_InvalidDate
Property MPInvalidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = MP_InvalidDate ];

/// MP_InvalidTime
Property MPInvalidTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = MP_InvalidTime ];

/// MP_Hold1
Property MPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MP_Hold1 ];

/// MP_Hold2
Property MPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MP_Hold2 ];

/// MP_Hold3
Property MPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MP_Hold3 ];

/// MP_Hold4
Property MPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MP_Hold4 ];

/// MP_Hold5
Property MPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MP_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMovePosition("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MP_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MP_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MP_EventProcess">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MP_EventType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MP_InvalidDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MP_InvalidReason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MP_InvalidTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MP_InvalidUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MP_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MP_MoveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MP_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQMovePosition</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMove">
<Global>^DHCEQMovePosition</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Move"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MP_LocationDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MP_MoveDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMovePositionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
