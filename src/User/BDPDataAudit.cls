/// 描述: 基础数据平台日志审计
/// 编写者：陈莹
/// 编写日期: 2015-1-5
Class User.BDPDataAudit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = BDP_DataAudit, StorageStrategy = SQLStorage ]
{

/// BDPDataAuditRowId
/// 码表日志ID
Property BDPDataAuditDataLogDR As User.BDPDataChangeLog [ Required, SqlColumnNumber = 2, SqlFieldName = BDPDataAudit_DataLogDR ];

/// 审计状态
Property BDPDataAuditStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 3, SqlFieldName = BDPDataAudit_Status ];

/// 审计日期
Property BDPDataAuditDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = BDPDataAudit_Date ];

/// 审计时间
Property BDPDataAuditTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BDPDataAudit_Time ];

/// 审计人
Property BDPDataAuditUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = BDPDataAudit_User ];

/// 审计结果	正常，异常
Property BDPDataAuditResult As %String(DISPLAYLIST = ",Normal,Abnormal", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",N,A") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = BDPDataAudit_Result ];

/// 审计备注
Property BDPDataAuditNote As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = BDPDataAudit_Note ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BDPDATAAUDIT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDPDataAudit_DataLogDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDPDataAudit_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDPDataAudit_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDPDataAudit_Result">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDPDataAudit_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDPDataAudit_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDPDataAudit_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BDPDATAAUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BDPDataAudit_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BDPDataAudit_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexLog">
<Global>^BDPDATAAUDIT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPDataAudit_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BDPDataAudit_DataLogDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDPDataAudit_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPDataAudit_RowId</SqlRowIdName>
<StreamLocation>User.BDPDataAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
