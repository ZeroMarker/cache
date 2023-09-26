Class User.CTLockSchedule Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_LockSchedule, StorageStrategy = Storage ]
{

/// 排版记录
Property CTSchedule As %String [ Required, SqlColumnNumber = 2, SqlFieldName = CT_Schedule ];

/// 序号 Required, 
Property CTLockQueueNo As %String [ SqlColumnNumber = 3, SqlFieldName = CT_LockQueueNo ];

/// 更新日期
Property CTUpdateDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = CT_UpdateDate ];

/// 更新时间
Property CTUpdatTime As %Time [ Required, SqlColumnNumber = 5, SqlFieldName = CT_UpdatTime ];

/// ss_user
Property CTUserID As %String [ Required, SqlColumnNumber = 6, SqlFieldName = CT_UserID ];

/// 有效标志 Y,N
Property CTActiveFlag As %String [ Required, SqlColumnNumber = 7, SqlFieldName = CT_ActiveFlag ];

/// 登记号
Property CTPatNo As %String [ SqlColumnNumber = 8, SqlFieldName = CT_PatNo ];

/// HIS交易流水号(订单号)
Property CTHISTradeNo As %String [ SqlColumnNumber = 9, SqlFieldName = CT_HISTradeNo ];

/// HIS就诊ID
Property CTHISAdmDr As %String [ SqlColumnNumber = 10, SqlFieldName = CT_HISAdmDr ];

/// 最后更新日期
Property CTLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CT_LastUpdateDate ];

/// 最后更新时间
Property CTLastUpdatTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CT_LastUpdatTime ];

/// 置无效更新人Person-个人   Demo-系统
Property CTLastUpdatUser As %String(DISPLAYLIST = ",Person,Demo", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",P,D") [ SqlColumnNumber = 13, SqlFieldName = CT_LastUpdatUser ];

/// 预约锁号号源方式CODE
Property CTAPPMeth As %String [ SqlColumnNumber = 14, SqlFieldName = CT_APPMeth ];

/// 第三方自动取消锁号时间 0不自动取消 为空走系统默认自动取消时间
Property CTAtuoCancelTime As %String [ SqlColumnNumber = 15, SqlFieldName = CT_AtuoCancelTime ];

/// 要进行挂号 和预约前 要把锁定的记录推迟的分钟数 和锁回归时间 岔开
Property CTActiveAddTime As %Time [ SqlColumnNumber = 16, SqlFieldName = CT_ActiveAddTime ];

Storage Storage
{
<SqlIdExpression>$i(^CTLS(0))</SqlIdExpression>
<SQLMap name="IndexAdmDr">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_HISAdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexData">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Data"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_Schedule}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_LockQueueNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_UpdateDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISTradNo">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISTradNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_HISTradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatNo">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_PatNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatNoSchedule">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatNoSchedule"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_PatNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_Schedule}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchedule1">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Schedule1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_Schedule}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_LockQueueNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchedulePatNo">
<Global>^CTLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchedulePatNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_Schedule}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_PatNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasteData">
<Data name="CT_APPMeth">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CT_ActiveAddTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CT_AtuoCancelTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CT_HISAdmDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CT_HISTradeNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CT_LastUpdatTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CT_LastUpdatUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CT_LockQueueNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CT_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CT_Schedule">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CT_UpdatTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CT_UserID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^CTLS</Global>
<RowIdSpec name="1">
<Field>CT_LSRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_LSRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CT_LSRowID</SqlRowIdName>
<StreamLocation>^User.CTLockScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
