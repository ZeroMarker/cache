/// 描述:组织机构行业分类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOrgInduCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgInduCategory ]
{

/// 组织机构行业分类代码
Property ORGICCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGIC_Code ];

/// 组织机构行业分类名称
Property ORGICDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGIC_Desc ];

/// 分类来源
Property ORGICSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ORGIC_Source ];

/// 是否有效(Y/N)
Property ORGICActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = ORGIC_Activity ];

/// 开始日期
Property ORGICStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = ORGIC_StartDate ];

/// 结束日期
Property ORGICEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ORGIC_EndDate ];

/// 系统创建日期
Property ORGICCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = ORGIC_CreateDate ];

/// 系统创建时间
Property ORGICCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = ORGIC_CreateTime ];

/// 系统创建人
Property ORGICCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = ORGIC_CreateUser ];

/// 系统排序号
Property ORGICSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = ORGIC_SeqNo ];

/// 系统最后更新日期
Property ORGICLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = ORGIC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGICLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = ORGIC_LastUpdateTime ];

/// 系统最新更新人
Property ORGICLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = ORGIC_LastUpdateUser ];

/// 拼音码
Property ORGICPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORGIC_PYCode ];

/// 五笔码
Property ORGICWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGIC_WBCode ];

/// 备注
Property ORGICMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGIC_Mark ];

/// 索引-代码
Index IndexCode On ORGICCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGICDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGICSeqNo;

Storage Default
{
<Data name="HOSOrgInduCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGICCode</Value>
</Value>
<Value name="3">
<Value>ORGICDesc</Value>
</Value>
<Value name="4">
<Value>ORGICSource</Value>
</Value>
<Value name="5">
<Value>ORGICActivity</Value>
</Value>
<Value name="6">
<Value>ORGICStartDate</Value>
</Value>
<Value name="7">
<Value>ORGICEndDate</Value>
</Value>
<Value name="8">
<Value>ORGICCreateDate</Value>
</Value>
<Value name="9">
<Value>ORGICCreateTime</Value>
</Value>
<Value name="10">
<Value>ORGICCreateUser</Value>
</Value>
<Value name="11">
<Value>ORGICSeqNo</Value>
</Value>
<Value name="12">
<Value>ORGICLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>ORGICLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>ORGICLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>ORGICPYCode</Value>
</Value>
<Value name="16">
<Value>ORGICWBCode</Value>
</Value>
<Value name="17">
<Value>ORGICMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgInduCategoryD</DataLocation>
<DefaultData>HOSOrgInduCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgInduCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgInduCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgInduCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
