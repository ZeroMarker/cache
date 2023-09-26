/// 描述:组织机构大类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOrgCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgCategory ]
{

/// 组织机构大类代码
Property ORGCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGC_Code ];

/// 组织机构大类名称
Property ORGCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGC_Desc ];

/// 分类来源
Property ORGCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ORGC_Source ];

/// 是否有效(Y/N)
Property ORGCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = ORGC_Activity ];

/// 开始日期
Property ORGCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = ORGC_StartDate ];

/// 结束日期
Property ORGCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ORGC_EndDate ];

/// 系统创建日期
Property ORGCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = ORGC_CreateDate ];

/// 系统创建时间
Property ORGCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = ORGC_CreateTime ];

/// 系统创建人
Property ORGCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = ORGC_CreateUser ];

/// 系统排序号
Property ORGCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = ORGC_SeqNo ];

/// 系统最后更新日期
Property ORGCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = ORGC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = ORGC_LastUpdateTime ];

/// 系统最新更新人
Property ORGCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = ORGC_LastUpdateUser ];

/// 拼音码
Property ORGCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORGC_PYCode ];

/// 五笔码
Property ORGCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGC_WBCode ];

/// 备注
Property ORGCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGC_Mark ];

/// 索引-代码
Index IndexCode On ORGCCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGCSeqNo;

Storage Default
{
<Data name="HOSOrgCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGCCode</Value>
</Value>
<Value name="3">
<Value>ORGCDesc</Value>
</Value>
<Value name="4">
<Value>ORGCSource</Value>
</Value>
<Value name="5">
<Value>ORGCActivity</Value>
</Value>
<Value name="6">
<Value>ORGCStartDate</Value>
</Value>
<Value name="7">
<Value>ORGCEndDate</Value>
</Value>
<Value name="8">
<Value>ORGCCreateDate</Value>
</Value>
<Value name="9">
<Value>ORGCCreateTime</Value>
</Value>
<Value name="10">
<Value>ORGCCreateUser</Value>
</Value>
<Value name="11">
<Value>ORGCSeqNo</Value>
</Value>
<Value name="12">
<Value>ORGCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>ORGCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>ORGCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>ORGCPYCode</Value>
</Value>
<Value name="16">
<Value>ORGCWBCode</Value>
</Value>
<Value name="17">
<Value>ORGCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgCategoryD</DataLocation>
<DefaultData>HOSOrgCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
