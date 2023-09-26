Class User.DHCAccQueryFoot Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccQF_RowID, SqlTableName = DHC_AccQueryFoot, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCAccQueryFootSub As User.DHCAccQueryFootSub [ Cardinality = children, Inverse = AccQFSParRef ];

/// AccPF_Date
Property AccQFDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = AccQF_Date ];

/// AccPF_Time
Property AccQFTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = AccQF_Time ];

/// AccPF_User_DR
Property AccQFUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AccQF_User_DR ];

/// AccQF_LastDate
Property AccQFLastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AccQF_LastDate ];

/// AccPF_LastTime
Property AccQFLastTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AccQF_LastTime ];

/// AccPF_PreLeftSum
Property AccQFPreLeftSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AccQF_PreLeftSum ];

/// AccPF_PreSum
Property AccQFPreSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AccQF_PreSum ];

/// AccPF_CardPaySum
Property AccQFCardPaySum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AccQF_CardPaySum ];

/// AccPF_LeftSum
Property AccQFLeftSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AccQF_LeftSum ];

/// AccPF_RefundPreSum
Property AccQFRefundPreSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccQF_RefundPreSum ];

/// AccPF_AccPayINVSum
Property AccQFAccPayINVSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccQF_AccPayINVSum ];

/// AccPF_AccDepPaySum
Property AccQFAccDepPaySum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccQF_AccDepPaySum ];

/// AccPF_AccTimeType
Property AccQFAccTimeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccQF_AccTimeType ];

/// AccPF_CurQFSum
Property AccQFCurQFSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccQF_CurQFSum ];

/// AccPF_CurLeftQFSum
Property AccQFCurLeftQFSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AccQF_CurLeftQFSum ];

/// AccPF_HSDate
Property AccQFHSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = AccQF_HSDate ];

/// AccPF_Note1
Property AccQFNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AccQF_Note1 ];

/// AccPF_Note2
Property AccQFNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AccQF_Note2 ];

/// AccPF_Note3
Property AccQFNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AccQF_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACDTMPQUERY)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AccQF_AccDepPaySum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccQF_AccPayINVSum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccQF_AccTimeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccQF_CardPaySum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccQF_CurLeftQFSum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccQF_CurQFSum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccQF_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccQF_HSDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccQF_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccQF_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccQF_LeftSum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccQF_Note1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccQF_Note2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccQF_Note3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AccQF_PreLeftSum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccQF_PreSum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccQF_RefundPreSum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccQF_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccQF_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCACDTMPQUERY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AccQF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AccQF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCurDate">
<Global>^DHCACDTMPQUERYi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccQF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CurDateT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AccQF_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccQF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccQueryFootS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
