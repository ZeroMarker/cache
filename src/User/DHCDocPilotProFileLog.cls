Class User.DHCDocPilotProFileLog Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = FileLog_RowID, SqlTableName = DHCDoc_PilotProFileLog, StorageStrategy = SQLStorage ]
{

/// 项目代码
Property PPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PP_Code ];

/// 项目名称
Property PPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PP_Desc ];

/// 小结日期
Property BriefDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = Brief_Date ];

/// 关中心日期
Property CenterDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = Center_Date ];

/// 总结日期
Property SumDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = Sum_Date ];

/// PPS_UpdateUser_Dr
Property PPSUpdateUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PPSUpdate_UserDr ];

/// PPS_UpdateDate
Property PPSUpdateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = PPSUpdate_Date ];

/// PPS_UpdateTime
Property PPSUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PPSUpdate_Time ];

/// PPSUpdateUserIP 修改人的IP
Property PPSUpdateUserIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PPSUpdate_UserIP ];

Property DHCDocPilotProDr As DHCDocPilotProject [ SqlColumnNumber = 11, SqlFieldName = DHCDoc_PilotPro_Dr ];

Property PPSUpdateStr As %Library.String(COLLATION = "Exact", MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PPSUpdate_Str ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^FileLog(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Brief_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Center_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCDoc_PilotPro_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPSUpdate_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPSUpdate_Str">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPSUpdate_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPSUpdate_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPSUpdate_UserIP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Sum_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^FileLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{FileLog_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FileLog_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^FileLogs</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{FileLog_Row}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LogDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPSUpdate_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FileLog_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPCode">
<Global>^FileLogs</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{FileLog_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PPCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PP_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FileLog_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FileLog_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocPilotProFileLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
