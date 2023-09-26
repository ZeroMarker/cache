Class User.DHCEQNotice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = N_RowID, SqlTableName = DHC_EQNotice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// N_Title
Property NTitle As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = N_Title ];

/// N_Content
Property NContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = N_Content ];

/// N_PictureURL
Property NPictureURL As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = N_PictureURL ];

/// N_ContentURL
Property NContentURL As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = N_ContentURL ];

/// N_Remark
Property NRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = N_Remark ];

/// N_BeginDate
Property NBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = N_BeginDate ];

/// N_BeginTime
Property NBeginTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = N_BeginTime ];

/// N_EndDate
Property NEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = N_EndDate ];

/// N_EndTime
Property NEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = N_EndTime ];

/// N_AddUserDR
Property NAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = N_AddUserDR ];

/// N_AddDate
Property NAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = N_AddDate ];

/// N_AddTime
Property NAddTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = N_AddTime ];

/// N_SubmitUserDR
Property NSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = N_SubmitUserDR ];

/// N_SubmitDate
Property NSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = N_SubmitDate ];

/// N_SubmitTime
Property NSubmitTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = N_SubmitTime ];

/// N_Hold1
Property NHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = N_Hold1 ];

/// N_Hold2
Property NHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = N_Hold2 ];

/// N_Hold3
Property NHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = N_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQNotice("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="N_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="N_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="N_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="N_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="N_BeginTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="N_Content">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="N_ContentURL">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="N_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="N_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="N_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="N_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="N_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="N_PictureURL">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="N_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="N_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="N_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="N_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="N_Title">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQNotice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{N_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQNoticeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
