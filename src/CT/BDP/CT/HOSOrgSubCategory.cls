/// 描述:组织机构子类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOrgSubCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgSubCategory ]
{

/// 组织机构子类代码
Property ORGSCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGSC_Code ];

/// 组织机构子类名称
Property ORGSCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGSC_Desc ];

/// 组织机构大类-外键
Property ORGSCORGCCode As CT.BDP.CT.HOSOrgCategory [ SqlColumnNumber = 4, SqlFieldName = ORGSC_ORGCCode ];

/// 分类来源
Property ORGSCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORGSC_Source ];

/// 是否有效(Y/N)
Property ORGSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = ORGSC_Activity ];

/// 开始日期
Property ORGSCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORGSC_StartDate ];

/// 结束日期
Property ORGSCEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ORGSC_EndDate ];

/// 系统创建日期
Property ORGSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = ORGSC_CreateDate ];

/// 系统创建时间
Property ORGSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = ORGSC_CreateTime ];

/// 系统创建人
Property ORGSCCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORGSC_CreateUser ];

/// 系统排序号
Property ORGSCSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = ORGSC_SeqNo ];

/// 系统最后更新日期
Property ORGSCLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ORGSC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGSCLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ORGSC_LastUpdateTime ];

/// 系统最新更新人
Property ORGSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = ORGSC_LastUpdateUser ];

/// 拼音码
Property ORGSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGSC_PYCode ];

/// 五笔码
Property ORGSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGSC_WBCode ];

/// 备注
Property ORGSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ORGSC_Mark ];

/// 索引-代码
Index IndexCode On ORGSCCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGSCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGSCSeqNo;

/// 索引-组织机构大类-外键
Index IndexCategory On ORGSCORGCCode;

Storage Default
{
<Data name="HOSOrgSubCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGSCCode</Value>
</Value>
<Value name="3">
<Value>ORGSCDesc</Value>
</Value>
<Value name="4">
<Value>ORGSCORGCCode</Value>
</Value>
<Value name="5">
<Value>ORGSCSource</Value>
</Value>
<Value name="6">
<Value>ORGSCActivity</Value>
</Value>
<Value name="7">
<Value>ORGSCStartDate</Value>
</Value>
<Value name="8">
<Value>ORGSCEndDate</Value>
</Value>
<Value name="9">
<Value>ORGSCCreateDate</Value>
</Value>
<Value name="10">
<Value>ORGSCCreateTime</Value>
</Value>
<Value name="11">
<Value>ORGSCCreateUser</Value>
</Value>
<Value name="12">
<Value>ORGSCSeqNo</Value>
</Value>
<Value name="13">
<Value>ORGSCLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>ORGSCLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>ORGSCLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>ORGSCPYCode</Value>
</Value>
<Value name="17">
<Value>ORGSCWBCode</Value>
</Value>
<Value name="18">
<Value>ORGSCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgSubCategoryD</DataLocation>
<DefaultData>HOSOrgSubCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgSubCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgSubCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgSubCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
