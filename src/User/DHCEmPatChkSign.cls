Class User.DHCEmPatChkSign Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCS_RowID, SqlTableName = DHC_EmPatChkSign, StorageStrategy = SQLStorage ]
{

/// 预检表 PCS_Chk_Dr
Property PCSChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCS_Chk_Dr ];

/// 时间 PCS_Time
Property PCSTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PCS_Time ];

/// 体温 PCS_Temp
Property PCSTemp As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PCS_Temp ];

/// 心率HR PCS_Heart   //handong  2020-01-20  改为Text
Property PCSHeart As %Text(MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = PCS_Heart ];

/// 脉搏R PCS_PCS_Pulse   //handong  2020-01-20  改为Text
Property PCSPCSPulse As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = PCS_PCS_Pulse ];

/// 血压(BP)收缩压 PCS_SBP
Property PCSSBP As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PCS_SBP ];

/// 舒张压 PCS_DBP
Property PCSDBP As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PCS_DBP ];

/// 血氧饱合度SoP2 PCS_SoP2
Property PCSSoP2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PCS_SoP2 ];

/// 呼吸频率 Breathe PCS_Breathe   //handong  2020-01-20  改为Text
Property PCSBreathe As %Text(MAXLEN = 30) [ SqlColumnNumber = 10, SqlFieldName = PCS_Breathe ];

/// 血糖  PCS_GLU hxy 2018-06-25   //handong  2020-01-20  改为Text
Property PCSGLU As %Text(MAXLEN = 30) [ SqlColumnNumber = 11, SqlFieldName = PCS_GLU ];

/// 日期  PCS_Date   handong  2019-11-08
Property PCSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PCS_Date ];

/// 碳氧血红蛋白 PCS_COHb
Property PCSCOHb As %Text(MAXLEN = 30) [ SqlColumnNumber = 13, SqlFieldName = PCS_COHb ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCS_Breathe">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCS_COHb">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCS_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCS_DBP">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCS_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCS_GLU">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCS_Heart">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCS_PCS_Pulse">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCS_SBP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCS_SoP2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCS_Temp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCS_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkSignS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
