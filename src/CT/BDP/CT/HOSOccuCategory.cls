/// 描述:职业大类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOccuCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OccuCategory ]
{

/// 职业大类代码
Property OCCUCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OCCUC_Code ];

/// 职业大类名称
Property OCCUCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OCCUC_Desc ];

/// 是否有效(Y/N)
Property OCCUCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = OCCUC_Activity ];

/// 开始日期
Property OCCUCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = OCCUC_StartDate ];

/// 结束日期
Property OCCUCEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OCCUC_EndDate ];

/// 系统创建日期
Property OCCUCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = OCCUC_CreateDate ];

/// 系统创建时间
Property OCCUCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = OCCUC_CreateTime ];

/// 系统创建人
Property OCCUCCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = OCCUC_CreateUser ];

/// 系统排序号
Property OCCUCSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = OCCUC_SeqNo ];

/// 系统最后更新日期
Property OCCUCLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = OCCUC_LastUpdateDate ];

/// 系统最后更新时间
Property OCCUCLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = OCCUC_LastUpdateTime ];

/// 系统最新更新人
Property OCCUCLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = OCCUC_LastUpdateUser ];

/// 拼音码
Property OCCUCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = OCCUC_PYCode ];

/// 五笔码
Property OCCUCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OCCUC_WBCode ];

/// 备注
Property OCCUCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OCCUC_Mark ];

/// 索引-代码
Index IndexCode On OCCUCCode [ Unique ];

/// 索引-名称
Index IndexDesc On OCCUCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On OCCUCSeqNo;

Storage Default
{
<Data name="HOSOccuCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OCCUCCode</Value>
</Value>
<Value name="3">
<Value>OCCUCDesc</Value>
</Value>
<Value name="4">
<Value>OCCUCActivity</Value>
</Value>
<Value name="5">
<Value>OCCUCStartDate</Value>
</Value>
<Value name="6">
<Value>OCCUCEndDate</Value>
</Value>
<Value name="7">
<Value>OCCUCCreateDate</Value>
</Value>
<Value name="8">
<Value>OCCUCCreateTime</Value>
</Value>
<Value name="9">
<Value>OCCUCCreateUser</Value>
</Value>
<Value name="10">
<Value>OCCUCSeqNo</Value>
</Value>
<Value name="11">
<Value>OCCUCLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>OCCUCLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>OCCUCLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>OCCUCPYCode</Value>
</Value>
<Value name="15">
<Value>OCCUCWBCode</Value>
</Value>
<Value name="16">
<Value>OCCUCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOccuCategoryD</DataLocation>
<DefaultData>HOSOccuCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOccuCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOccuCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOccuCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
