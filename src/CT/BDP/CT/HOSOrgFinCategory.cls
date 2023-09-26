/// 描述:机构分类小类字典-机构分类中类字典的子表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgFinCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgFinCategory ]
{

///  机构分类中类字典（父表）
Relationship SecCategoryParRef As CT.BDP.CT.HOSOrgSecCategory [ Cardinality = parent, Inverse = ChildOrgFinCategory ];

/// 机构小类代码
Property OFCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OFC_Code ];

/// 机构小类名称
Property OFCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OFC_Desc ];

/// 注释
Property OFCComments As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OFC_Comments ];

/// 分类来源
Property OFCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OFC_Source ];

/// 是否有效(Y/N)
Property OFCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = OFC_Activity ];

/// 开始日期
Property OFCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = OFC_StartDate ];

/// 结束日期
Property OFCEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OFC_EndDate ];

/// 系统创建日期
Property OFCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = OFC_CreateDate ];

/// 系统创建时间
Property OFCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = OFC_CreateTime ];

/// 系统创建人
Property OFCCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = OFC_CreateUser ];

/// 系统排序号
Property OFCSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = OFC_SeqNo ];

/// 系统最后更新日期
Property OFCLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = OFC_LastUpdateDate ];

/// 系统最后更新时间
Property OFCLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = OFC_LastUpdateTime ];

/// 系统最新更新人
Property OFCLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = OFC_LastUpdateUser ];

/// 拼音码
Property OFCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OFC_PYCode ];

/// 五笔码
Property OFCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OFC_WBCode ];

/// 备注
Property OFCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = OFC_Mark ];

/// 索引-代码
Index IndexCode On OFCCode;

/// 索引-名称
Index IndexDesc On OFCDesc;

/// 索引-系统排序号
Index IndexSeqNo On OFCSeqNo;

/// 索引-父表ParRef
Index IndexParRef On SecCategoryParRef;

/// 索引- 机构小类（父表）-代码
Index IndexParRefCode On (SecCategoryParRef, OFCCode) [ Unique ];

/// 索引- 机构小类（父表）-描述
Index IndexParRefDesc On (SecCategoryParRef, OFCDesc) [ Unique ];

Storage Default
{
<Data name="HOSOrgFinCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OFCCode</Value>
</Value>
<Value name="3">
<Value>OFCDesc</Value>
</Value>
<Value name="4">
<Value>OFCComments</Value>
</Value>
<Value name="5">
<Value>OFCSource</Value>
</Value>
<Value name="6">
<Value>OFCActivity</Value>
</Value>
<Value name="7">
<Value>OFCStartDate</Value>
</Value>
<Value name="8">
<Value>OFCEndDate</Value>
</Value>
<Value name="9">
<Value>OFCCreateDate</Value>
</Value>
<Value name="10">
<Value>OFCCreateTime</Value>
</Value>
<Value name="11">
<Value>OFCCreateUser</Value>
</Value>
<Value name="12">
<Value>OFCSeqNo</Value>
</Value>
<Value name="13">
<Value>OFCLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>OFCLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>OFCLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>OFCPYCode</Value>
</Value>
<Value name="17">
<Value>OFCWBCode</Value>
</Value>
<Value name="18">
<Value>OFCMark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildOrgFinCategory")</DataLocation>
<DefaultData>HOSOrgFinCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgSecCategoryC("ChildOrgFinCategory")</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgFinCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgFinCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
