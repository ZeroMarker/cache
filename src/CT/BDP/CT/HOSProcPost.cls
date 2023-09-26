/// 描述:流程岗位
/// 创建人：鲁俊文
/// 创建日期：2023-2-6
Class CT.BDP.CT.HOSProcPost Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProcPost ]
{

/// 流程岗位代码
Property PPOSTCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PPOST_Code ];

/// 流程岗位名称
Property PPOSTDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PPOST_Desc ];

/// 业务单元代码
Property PPOSTBUCode As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PPOST_BUCode ];

/// 岗位字典代码
Property PPOSTPOSTCCode As CT.BDP.CT.HOSPostDict [ SqlColumnNumber = 5, SqlFieldName = PPOST_POSTCCode ];

/// 是否有效(Y/N)
Property PPOSTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = PPOST_Activity ];

/// 开始日期
Property PPOSTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PPOST_StartDate ];

/// 结束日期
Property PPOSTEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PPOST_EndDate ];

/// 系统创建日期
Property PPOSTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = PPOST_CreateDate ];

/// 系统创建时间
Property PPOSTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = PPOST_CreateTime ];

/// 系统创建人
Property PPOSTCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PPOST_CreateUser ];

/// 系统排序号
Property PPOSTSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = PPOST_SeqNo ];

/// 系统最后更新日期
Property PPOSTLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PPOST_LastUpdateDate ];

/// 系统最后更新时间
Property PPOSTLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PPOST_LastUpdateTime ];

/// 系统最新更新人
Property PPOSTLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = PPOST_LastUpdateUser ];

/// 拼音码
Property PPOSTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PPOST_PYCode ];

/// 五笔码
Property PPOSTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PPOST_WBCode ];

/// 备注
Property PPOSTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PPOST_Mark ];

/// 索引-流程岗位代码
Index IndexCode On PPOSTCode;

/// 索引-流程岗位名称
Index IndexDesc On PPOSTDesc;

Storage Default
{
<Data name="HOSProcPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PPOSTCode</Value>
</Value>
<Value name="3">
<Value>PPOSTDesc</Value>
</Value>
<Value name="4">
<Value>PPOSTBUCode</Value>
</Value>
<Value name="5">
<Value>PPOSTPOSTCCode</Value>
</Value>
<Value name="6">
<Value>PPOSTActivity</Value>
</Value>
<Value name="7">
<Value>PPOSTStartDate</Value>
</Value>
<Value name="8">
<Value>PPOSTEndDate</Value>
</Value>
<Value name="9">
<Value>PPOSTCreateDate</Value>
</Value>
<Value name="10">
<Value>PPOSTCreateTime</Value>
</Value>
<Value name="11">
<Value>PPOSTCreateUser</Value>
</Value>
<Value name="12">
<Value>PPOSTSeqNo</Value>
</Value>
<Value name="13">
<Value>PPOSTLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>PPOSTLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>PPOSTLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>PPOSTPYCode</Value>
</Value>
<Value name="17">
<Value>PPOSTWBCode</Value>
</Value>
<Value name="18">
<Value>PPOSTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProcPostD</DataLocation>
<DefaultData>HOSProcPostDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProcPostD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProcPostI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProcPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
