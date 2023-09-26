/// 排班管理-请假
Class User.PIVALeave Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_Leave, StorageStrategy = CacheSQLStorage ]
{

/// 配液中心
Property PLLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PL_Loc_Dr ];

/// 人员
Property PLUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PL_User_Dr ];

/// 请假类型
Property PLLeaveTypeDr As User.PIVALeaveType [ SqlColumnNumber = 4, SqlFieldName = PL_LeaveType_Dr ];

/// 请假原因
Property PLReason As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PL_Reason ];

/// 请假开始日期
Property PLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PL_StartDate ];

/// 请假开结束日期
Property PLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PL_EndDate ];

/// 创建日期
Property PLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PL_Date ];

/// 创建时间
Property PLTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PL_Time ];

/// 审核人员
Property PLAuditUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PL_AuditUser_Dr ];

/// 审核日期
Property PLAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PL_AuditDate ];

/// 审核时间
Property PLAuditTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PL_AuditTime ];

/// 完成人员
Property PLFinishUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PL_FinishUser_Dr ];

/// 完成日期
Property PLFinishDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PL_FinishDate ];

/// 完成时间
Property PLFinishTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PL_FinishTime ];

/// 审核状态:0(申请中),1(已审批),2(已完成)
Property PLStatus As %Library.String [ SqlColumnNumber = 16, SqlFieldName = PL_Status ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Busi.PIVA.Leave(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PL_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PL_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PL_AuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PL_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PL_FinishUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PL_LeaveType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_Reason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PL_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Busi.PIVA.Leave</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="LocUserDate">
<Global>^Busi.PIVA.Leave</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocUseStDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PL_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PL_RowId</SqlRowIdName>
<StreamLocation>^Busi.PIVA.LeaveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
