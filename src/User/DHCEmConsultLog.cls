Class User.DHCEmConsultLog Extends %Persistent [ SqlRowIdName = ECL_RowID, SqlTableName = DHC_EmConsultLog, StorageStrategy = SQLStorage ]
{

/// ECL_Cst_Ref	项目id
Property ECLCstRef As User.DHCEmConsultItm [ SqlColumnNumber = 2, SqlFieldName = ECL_Cst_Ref ];

/// ECL_User_Dr	操作员
Property ECLUserDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ECL_User_Dr ];

/// ECL_Status_Dr	报告状态
Property ECLStatusDr As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ECL_Status_Dr ];

/// ECL_Date   操作日期
Property ECLDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = ECL_Date ];

/// ECL_Time   操作时间
Property ECLTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ECL_Time ];

/// ECL_Notes	操作备注
Property ECLNotes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ECL_Notes ];

/// ECL_CycleCode	会诊闭环code
Property ECLCycleCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ECL_CycleCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ECL_Cst_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ECL_CycleCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ECL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ECL_Notes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ECL_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ECL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ECL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCONL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ECL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ECL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCstParef">
<Global>^DHCEMCONL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ECL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECL_Cst_Ref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserCst">
<Global>^DHCEMCONL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ECL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECL_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECL_Cst_Ref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ECL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
