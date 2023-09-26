Class User.DHCEQPVisitorLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VL_RowID, SqlTableName = DHC_EQPVisitorLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// VL_SourceType
Property OLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VL_SourceType ];

/// VL_SourceID
Property OLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VL_SourceID ];

/// VL_Times
Property OLTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VL_Times ];

/// VL_Date
Property OLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = VL_Date ];

/// VL_Time
Property OLTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = VL_Time ];

/// VL_User
Property OLUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VL_User ];

/// VL_Client
Property VLClient As %Library.String(DISPLAYLIST = ",PC端,微信端", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 8, SqlFieldName = VL_Client ];

/// VL_AccessIP
Property VLAccessIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = VL_AccessIP ];

/// VL_Remark
Property OLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = VL_Remark ];

/// VL_Hold1
Property OLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = VL_Hold1 ];

/// VL_Hold2
Property OLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = VL_Hold2 ];

/// VL_Hold3
Property OLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = VL_Hold3 ];

/// VL_Hold4
Property OLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = VL_Hold4 ];

/// VL_Hold5
Property OLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = VL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPVisitorLog("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VL_AccessIP">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VL_Client">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="VL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VL_Times">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VL_User">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQPVisitorLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPVisitorLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
