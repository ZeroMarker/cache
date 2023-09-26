/// 排班管理-请假类型字典
Class User.PIVALeaveType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = PIVA_LeaveType, StorageStrategy = CacheSQLStorage ]
{

/// 寒暑假类型
Property PLTDesc As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PLT_Desc ];

/// 请假天数上限
Property PLTLimitDays As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PLT_LimitDays ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Code.PIVA.LeaveType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PLT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLT_LimitDays">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Code.PIVA.LeaveType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PLT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PLT_RowId</SqlRowIdName>
<StreamLocation>^Code.PIVA.LeaveTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
