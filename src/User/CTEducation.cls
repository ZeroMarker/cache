/// CT Education(1547)
Class User.CTEducation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Education, StorageStrategy = SQLStorage ]
{

/// 学历代码
Property EDUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = EDU_Code ];

/// 学历名称
Property EDUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EDU_Desc ];

/// 学历层级
Property EDUClass As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EDU_Class ];

/// 状态
Property EDUStatus As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EDU_Status ];

/// 是否有效(Y/N)
Property EDUActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = EDU_Activity ];

/// 开始日期
Property EDUStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = EDU_StartDate ];

/// 结束日期
Property EDUEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = EDU_EndDate ];

/// 系统创建日期
Property EDUCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = EDU_CreateDate ];

/// 系统创建时间
Property EDUCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = EDU_CreateTime ];

/// 系统创建人
Property EDUCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = EDU_CreateUser ];

/// 系统排序号
Property EDUSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = EDU_SeqNo ];

/// 系统最后更新日期
Property EDULastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = EDU_LastUpdateDate ];

/// 系统最后更新时间
Property EDULastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = EDU_LastUpdateTime ];

/// 系统最新更新人
Property EDULastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = EDU_LastUpdateUser ];

/// 拼音码
Property EDUPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = EDU_PYCode ];

/// 五笔码
Property EDUWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = EDU_WBCode ];

/// 备注
Property EDUMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = EDU_Mark ];

Index EDUCodeUnqIdx1 On EDUCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTEducation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTEducation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTEducation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTEducation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTEducation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTEducation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTEducation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTEducation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTEducation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTEducation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("EDU",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EDU_Activity">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EDU_Class">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EDU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EDU_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EDU_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EDU_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EDU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EDU_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EDU_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EDU_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EDU_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EDU_Mark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EDU_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EDU_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EDU_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EDU_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EDU_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EDU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EDU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EDU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EDU_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EDU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EDU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EDU_RowId</SqlRowIdName>
<StreamLocation>^User.CTEducationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
