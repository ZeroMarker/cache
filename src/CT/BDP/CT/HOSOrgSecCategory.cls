/// 描述:机构分类中类字典-机构分类大类字典的子表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgSecCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgSecCategory ]
{

///  机构分类大类字典（父表）
Relationship PriCategoryParRef As CT.BDP.CT.HOSOrgPriCategory [ Cardinality = parent, Inverse = ChildOrgSecCategory ];

///  机构分类中类字典（子表）
Relationship ChildOrgFinCategory As CT.BDP.CT.HOSOrgFinCategory [ Cardinality = children, Inverse = SecCategoryParRef ];

/// 机构中类代码
Property OSCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OSC_Code ];

/// 机构中类名称
Property OSCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OSC_Desc ];

/// 分类来源
Property OSCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OSC_Source ];

/// 是否有效(Y/N)
Property OSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = OSC_Activity ];

/// 开始日期
Property OSCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = OSC_StartDate ];

/// 结束日期
Property OSCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OSC_EndDate ];

/// 系统创建日期
Property OSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = OSC_CreateDate ];

/// 系统创建时间
Property OSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = OSC_CreateTime ];

/// 系统创建人
Property OSCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = OSC_CreateUser ];

/// 系统排序号
Property OSCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = OSC_SeqNo ];

/// 系统最后更新日期
Property OSCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = OSC_LastUpdateDate ];

/// 系统最后更新时间
Property OSCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OSC_LastUpdateTime ];

/// 系统最新更新人
Property OSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OSC_LastUpdateUser ];

/// 拼音码
Property OSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OSC_PYCode ];

/// 五笔码
Property OSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OSC_WBCode ];

/// 备注
Property OSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OSC_Mark ];

/// 索引-代码
Index IndexCode On OSCCode [ Unique ];

/// 索引-名称
Index IndexDesc On OSCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On OSCSeqNo;

/// 索引-父表ParRef
Index IndexParRef On PriCategoryParRef;

/// 索引-ParRef-代码
Index IndexParRefCode On (PriCategoryParRef, OSCCode) [ Unique ];

/// 索引-ParRef-名称
Index IndexParRefDesc On (PriCategoryParRef, OSCDesc) [ Unique ];

Storage Default
{
<Data name="HOSOrgSecCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OSCCode</Value>
</Value>
<Value name="3">
<Value>OSCDesc</Value>
</Value>
<Value name="4">
<Value>OSCSource</Value>
</Value>
<Value name="5">
<Value>OSCActivity</Value>
</Value>
<Value name="6">
<Value>OSCStartDate</Value>
</Value>
<Value name="7">
<Value>OSCEndDate</Value>
</Value>
<Value name="8">
<Value>OSCCreateDate</Value>
</Value>
<Value name="9">
<Value>OSCCreateTime</Value>
</Value>
<Value name="10">
<Value>OSCCreateUser</Value>
</Value>
<Value name="11">
<Value>OSCSeqNo</Value>
</Value>
<Value name="12">
<Value>OSCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>OSCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>OSCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>OSCPYCode</Value>
</Value>
<Value name="16">
<Value>OSCWBCode</Value>
</Value>
<Value name="17">
<Value>OSCMark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildOrgSecCategory")</DataLocation>
<DefaultData>HOSOrgSecCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgPriCategoryC("ChildOrgSecCategory")</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgSecCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgSecCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
