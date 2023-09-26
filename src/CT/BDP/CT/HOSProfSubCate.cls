/// 描述:职务子类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfSubCate Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfSubCate ]
{

///  职务大类（父表）
Relationship CategoryParRef As CT.BDP.CT.HOSProfCategory [ Cardinality = parent, Inverse = ChildSubCate ];

///  职务专业代码（子表）
Relationship ChildMajor As CT.BDP.CT.HOSProfMajor [ Cardinality = children, Inverse = SubCateParRef ];

/// 职务子类代码
Property PROFSCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFSC_Code ];

/// 职务子类名称
Property PROFSCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFSC_Desc ];

/// 分类来源
Property PROFSCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROFSC_Source ];

/// 是否有效(Y/N)
Property PROFSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = PROFSC_Activity ];

/// 开始日期
Property PROFSCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PROFSC_StartDate ];

/// 结束日期
Property PROFSCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PROFSC_EndDate ];

/// 系统创建日期
Property PROFSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFSC_CreateDate ];

/// 系统创建时间
Property PROFSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = PROFSC_CreateTime ];

/// 系统创建人
Property PROFSCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PROFSC_CreateUser ];

/// 系统排序号
Property PROFSCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = PROFSC_SeqNo ];

/// 系统最后更新日期
Property PROFSCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PROFSC_LastUpdateDate ];

/// 系统最后更新时间
Property PROFSCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PROFSC_LastUpdateTime ];

/// 系统最新更新人
Property PROFSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PROFSC_LastUpdateUser ];

/// 拼音码
Property PROFSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFSC_PYCode ];

/// 五笔码
Property PROFSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFSC_WBCode ];

/// 备注
Property PROFSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFSC_Mark ];

/// 索引-代码
Index IndexCode On PROFSCCode;

/// 索引-名称
Index IndexDesc On PROFSCDesc;

/// 索引-系统排序号
Index IndexSeqNo On PROFSCSeqNo;

/// 索引-职务大类（父表）
Index IndexCategoryParRef On CategoryParRef;

/// 索引-ParRef-代码
Index IndexParRefCode On (CategoryParRef, PROFSCCode) [ Unique ];

/// 索引-ParRef-名称
Index IndexParRefDesc On (CategoryParRef, PROFSCDesc) [ Unique ];

Storage Default
{
<Data name="HOSProfSubCateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFSCCode</Value>
</Value>
<Value name="3">
<Value>PROFSCDesc</Value>
</Value>
<Value name="4">
<Value>PROFSCSource</Value>
</Value>
<Value name="5">
<Value>PROFSCActivity</Value>
</Value>
<Value name="6">
<Value>PROFSCStartDate</Value>
</Value>
<Value name="7">
<Value>PROFSCEndDate</Value>
</Value>
<Value name="8">
<Value>PROFSCCreateDate</Value>
</Value>
<Value name="9">
<Value>PROFSCCreateTime</Value>
</Value>
<Value name="10">
<Value>PROFSCCreateUser</Value>
</Value>
<Value name="11">
<Value>PROFSCSeqNo</Value>
</Value>
<Value name="12">
<Value>PROFSCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>PROFSCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>PROFSCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>PROFSCPYCode</Value>
</Value>
<Value name="16">
<Value>PROFSCWBCode</Value>
</Value>
<Value name="17">
<Value>PROFSCMark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSubCate")</DataLocation>
<DefaultData>HOSProfSubCateDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfCategoryC("ChildSubCate")</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfSubCateI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfSubCateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
