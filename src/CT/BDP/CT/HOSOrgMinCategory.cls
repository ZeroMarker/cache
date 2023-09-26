/// 描述:组织机构小类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOrgMinCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgMinCategory ]
{

/// 组织机构小类代码
Property ORGMCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGMC_Code ];

/// 组织机构小类名称
Property ORGMCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGMC_Desc ];

/// 组织机构子类-外键
Property ORGMCORGSCode As CT.BDP.CT.HOSOrgSubCategory [ SqlColumnNumber = 4, SqlFieldName = ORGMC_ORGSCode ];

/// 分类来源
Property ORGMCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORGMC_Source ];

/// 是否有效(Y/N)
Property ORGMCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = ORGMC_Activity ];

/// 开始日期
Property ORGMCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORGMC_StartDate ];

/// 结束日期
Property ORGMCEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ORGMC_EndDate ];

/// 系统创建日期
Property ORGMCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = ORGMC_CreateDate ];

/// 系统创建时间
Property ORGMCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = ORGMC_CreateTime ];

/// 系统创建人
Property ORGMCCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORGMC_CreateUser ];

/// 系统排序号
Property ORGMCSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = ORGMC_SeqNo ];

/// 系统最后更新日期
Property ORGMCLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ORGMC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGMCLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ORGMC_LastUpdateTime ];

/// 系统最新更新人
Property ORGMCLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = ORGMC_LastUpdateUser ];

/// 拼音码
Property ORGMCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGMC_PYCode ];

/// 五笔码
Property ORGMCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGMC_WBCode ];

/// 备注
Property ORGMCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ORGMC_Mark ];

/// 索引-代码
Index IndexCode On ORGMCCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGMCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGMCSeqNo;

/// 索引-组织机构子类-外键
Index IndexSubCategory On ORGMCORGSCode;

Storage Default
{
<Data name="HOSOrgMinCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGMCCode</Value>
</Value>
<Value name="3">
<Value>ORGMCDesc</Value>
</Value>
<Value name="4">
<Value>ORGMCORGSCode</Value>
</Value>
<Value name="5">
<Value>ORGMCSource</Value>
</Value>
<Value name="6">
<Value>ORGMCActivity</Value>
</Value>
<Value name="7">
<Value>ORGMCStartDate</Value>
</Value>
<Value name="8">
<Value>ORGMCEndDate</Value>
</Value>
<Value name="9">
<Value>ORGMCCreateDate</Value>
</Value>
<Value name="10">
<Value>ORGMCCreateTime</Value>
</Value>
<Value name="11">
<Value>ORGMCCreateUser</Value>
</Value>
<Value name="12">
<Value>ORGMCSeqNo</Value>
</Value>
<Value name="13">
<Value>ORGMCLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>ORGMCLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>ORGMCLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>ORGMCPYCode</Value>
</Value>
<Value name="17">
<Value>ORGMCWBCode</Value>
</Value>
<Value name="18">
<Value>ORGMCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgMinCategoryD</DataLocation>
<DefaultData>HOSOrgMinCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgMinCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgMinCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgMinCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
