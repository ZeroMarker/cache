Class User.DHCMDTLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ML_RowID, SqlTableName = DHC_MDTLog, StorageStrategy = SQLStorage ]
{

/// ML_Cst_Ref  会诊ID，插入状态为主表ID，签到为子表ID
Property MLCstRef As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ML_Cst_Ref ];

/// ML_User_Dr  操作用户
Property MLUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = ML_User_Dr ];

/// ML_Status_Dr 状态ID
Property MLStatusDr As User.DHCMDTConsStatus [ SqlColumnNumber = 4, SqlFieldName = ML_Status_Dr ];

/// ML_Date  操作日期
Property MLDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = ML_Date ];

/// ML_Time  操作时间
Property MLTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ML_Time ];

/// ML_Time  操作备注
Property MLNotes As %Library.Text(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = ML_Notes ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDTL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ML_Cst_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ML_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ML_Notes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ML_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ML_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ML_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCst">
<Global>^DHCMDTL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CstRef"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ML_Cst_Ref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTLOGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
