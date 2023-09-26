Class User.DHCDocHZYYExamResult Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = HZYYER_RowId, SqlTableName = DHC_DocHZYYExamResult, StorageStrategy = SQLStorage ]
{

/// 审核药师工号
Property HZYYERCheckPharmId As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HZYYER_CheckPharmId ];

/// 审核药师名称
Property HZYYERCheckPharmName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HZYYER_CheckPharmName ];

/// 就诊流水号
Property HZYYERAdmDR As User.PAAdm [ SqlColumnNumber = 4, SqlFieldName = HZYYER_Adm_DR ];

/// 处方号
Property HZYYERPrescNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HZYYER_PrescNo ];

/// 组号
Property HZYYERGroupNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HZYYER_GroupNo ];

/// 成功标识 0:审核不通过,1:审核通过,2:超时通过,3:自动通过,5:失效药嘱通过,6:进行待审
Property HZYYERIsSuccess As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HZYYER_IsSuccess ];

/// 状态 1:可双签名或修改,0:必须修改,2:审核通过不做处理
Property HZYYERStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HZYYER_Status ];

/// 一条警示信息的唯一id
Property HZYYERInfoId As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HZYYER_InfoId ];

/// 医嘱id
Property HZYYEROeoriDR As User.OEOrdItem [ SqlColumnNumber = 10, SqlFieldName = HZYYER_Oeori_DR ];

/// 错误等级
Property HZYYERSeverity As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = HZYYER_Severity ];

/// 错误信息
Property HZYYERErrorInfo As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HZYYER_ErrorInfo ];

/// 建议
Property HZYYERAdvice As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = HZYYER_Advice ];

/// 最终状态 用于记录双签还是修改 S:双签;U:修改 F:超时HIS通过
Property HZYYERLastStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = HZYYER_LastStatus ];

/// 双签内容
Property HZYYERDoubleSign As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = HZYYER_DoubleSign ];

/// 创建日期
Property HZYYERCreateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = HZYYER_CreateDate ];

/// 创建时间
Property HZYYERCreateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = HZYYER_CreateTime ];

/// 更新日期
Property HZYYERUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = HZYYER_UpdateDate ];

/// 更新时间
Property HZYYERUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = HZYYER_UpdateTime ];

/// 更新用户
Property HZYYERUpdateUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = HZYYER_UpdateUser_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocHZYYER(0))</SqlIdExpression>
<SQLMap name="DtataMaster">
<Data name="HZYYER_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HZYYER_Advice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HZYYER_CheckPharmId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HZYYER_CheckPharmName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HZYYER_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HZYYER_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HZYYER_DoubleSign">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HZYYER_ErrorInfo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HZYYER_GroupNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HZYYER_InfoId">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HZYYER_IsSuccess">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HZYYER_LastStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HZYYER_Oeori_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HZYYER_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HZYYER_Severity">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HZYYER_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HZYYER_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HZYYER_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HZYYER_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCDocHZYYER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HZYYER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HZYYER_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCDocHZYYER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HZYYER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HZYYER_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HZYYER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupNo">
<Global>^DHCDocHZYYER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HZYYER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HZYYER_GroupNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HZYYER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeori">
<Global>^DHCDocHZYYER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HZYYER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HZYYER_Oeori_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HZYYER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCDocHZYYER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HZYYER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HZYYER_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HZYYER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HZYYER_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocHZYYExamResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
