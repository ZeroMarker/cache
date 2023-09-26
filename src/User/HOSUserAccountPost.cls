/// 描述:系统账户岗位表
/// 创建人：基础数据平台 gaoshanshan
/// 创建日期：2022-11-30
Class User.HOSUserAccountPost Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = HOS_UserAccountPost, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On USERPOSTChildsub [ IdKey, PrimaryKey, Unique ];

/// 用户表（父表）
Relationship USERPOSTParRef As SSUser [ Cardinality = parent, Inverse = ChildHOSUserAccountPost ];

/// Childsub
Property USERPOSTChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"USERPOST",0))}, SqlColumnNumber = 2, SqlFieldName = USERPOST_Childsub ];

/// 岗位代码-外键
Property USERPOSTPostCode As CT.BDP.CT.HOSPost [ Required, SqlColumnNumber = 3, SqlFieldName = USERPOST_PostCode ];

/// 是否有效(Y/N)
Property USERPOSTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = USERPOST_Activity ];

/// 开始日期
Property USERPOSTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = USERPOST_StartDate ];

/// 结束日期
Property USERPOSTEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = USERPOST_EndDate ];

/// 系统创建日期
Property USERPOSTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = USERPOST_CreateDate ];

/// 系统创建时间
Property USERPOSTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = USERPOST_CreateTime ];

/// 系统创建人
Property USERPOSTCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = USERPOST_CreateUser ];

/// 系统排序号
Property USERPOSTSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = USERPOST_SeqNo ];

/// 系统最后更新日期
Property USERPOSTLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = USERPOST_LastUpdateDate ];

/// 系统最后更新时间
Property USERPOSTLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = USERPOST_LastUpdateTime ];

/// 系统最新更新人
Property USERPOSTLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = USERPOST_LastUpdateUser ];

/// 拼音码
Property USERPOSTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = USERPOST_PYCode ];

/// 五笔码
Property USERPOSTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = USERPOST_WBCode ];

/// 备注
Property USERPOSTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = USERPOST_Mark ];

/// 默认标识
Property USERPOSTDefault As %String [ InitialExpression = "Y", SqlColumnNumber = 17, SqlFieldName = USERPOST_Default ];

/// 索引-岗位代码-外键
Index IndexPostCode On USERPOSTPostCode;

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="USERPOST_Activity">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="USERPOST_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="USERPOST_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="USERPOST_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="USERPOST_Default">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="USERPOST_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="USERPOST_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="USERPOST_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="USERPOST_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="USERPOST_Mark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="USERPOST_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="USERPOST_PostCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="USERPOST_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="USERPOST_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="USERPOST_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>USERPOST_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USERPOST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USERPOST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDefault">
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>USERPOST_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USERPOST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Default"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{USERPOST_Default}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{USERPOST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPost">
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>USERPOST_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USERPOST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Post"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{USERPOST_PostCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{USERPOST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.HOSUserAccountPostS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
