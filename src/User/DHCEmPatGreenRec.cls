Class User.DHCEmPatGreenRec Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGR_RowID, SqlTableName = DHC_EmPatGreenRec, StorageStrategy = SQLStorage ]
{

/// 预检表 PGR_Chk_Dr
Property PGRChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PGR_Chk_Dr ];

/// 绿色通道开始日期 PGR_GreenStartDate
Property PGRGreenStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PGR_GreenStartDate ];

/// 绿色通道开始时间 PGR_GreenStartTime
Property PGRGreenStartTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PGR_GreenStartTime ];

/// 绿色通道结束日期 PGR_GreenEndDate
Property PGRGreenEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PGR_GreenEndDate ];

/// 绿色通道结束时间 PGR_GreenEndTime
Property PGRGreenEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PGR_GreenEndTime ];

/// 就诊ID PGR_Adm_Dr
Property PGRAdmDr As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = PGR_Adm_Dr ];

/// 操作人id PGR_Operator
Property PGROperator As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PGR_Operator ];

/// 操作日期 PGR_OperateDate
Property PGROperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PGR_OperateDate ];

/// 操作时间 PGR_OperateTime
Property PGROperateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PGR_OperateTime ];

/// 绿色通道结束操作人id PGR_XOperator
Property PGRXOperator As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PGR_XOperator ];

/// 绿色通道结束操作日期 PGR_XOperateDate
Property PGRXOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PGR_XOperateDate ];

/// 绿色通道结束操作时间 PGR_XOperateTime
Property PGRXOperateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PGR_XOperateTime ];

/// 安全组
Property PGRGroup As %String [ SqlColumnNumber = 14, SqlFieldName = PGR_Group ];

/// 原因
Property PGRReasonDr As User.DHCEmDicItem [ SqlColumnNumber = 15, SqlFieldName = PGR_Reason_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPGR)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCEMPGR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PGR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmChkLev">
<Global>^DHCEMPGR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PGR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmChkLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PGR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGR_Chk_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PGR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMPGR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PGR_OperateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPGR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PGR_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PGR_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGR_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGR_GreenEndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGR_GreenEndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGR_GreenStartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGR_GreenStartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGR_Group">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PGR_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PGR_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGR_Operator">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGR_Reason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGR_XOperateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGR_XOperateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGR_XOperator">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEMPGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PGR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PGR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatGreenRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
