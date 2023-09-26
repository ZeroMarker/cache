/// 描述:职务专业代码字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfMajor Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfMajor ]
{

///  职务子类（父表）
Relationship SubCateParRef As CT.BDP.CT.HOSProfSubCate [ Cardinality = parent, Inverse = ChildMajor ];

/// 职务专业代码
Property PROFMCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFM_Code ];

/// 职务专业名称
Property PROFMDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFM_Desc ];

/// 分类来源
Property PROFMSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROFM_Source ];

/// 是否有效(Y/N)
Property PROFMActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = PROFM_Activity ];

/// 开始日期
Property PROFMStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PROFM_StartDate ];

/// 结束日期
Property PROFMEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PROFM_EndDate ];

/// 系统创建日期
Property PROFMCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFM_CreateDate ];

/// 系统创建时间
Property PROFMCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = PROFM_CreateTime ];

/// 系统创建人
Property PROFMCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PROFM_CreateUser ];

/// 系统排序号
Property PROFMSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = PROFM_SeqNo ];

/// 系统最后更新日期
Property PROFMLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PROFM_LastUpdateDate ];

/// 系统最后更新时间
Property PROFMLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PROFM_LastUpdateTime ];

/// 系统最新更新人
Property PROFMLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PROFM_LastUpdateUser ];

/// 拼音码
Property PROFMPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFM_PYCode ];

/// 五笔码
Property PROFMWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFM_WBCode ];

/// 备注
Property PROFMMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFM_Mark ];

/// 索引-代码
Index IndexCode On PROFMCode;

/// 索引-名称
Index IndexDesc On PROFMDesc;

/// 索引-系统排序号
Index IndexSeqNo On PROFMSeqNo;

/// 索引- 职务子类（父表）
Index IndexSubCateParRef On SubCateParRef;

/// 索引- 职务子类（父表）-代码
Index IndexParRefCode On (SubCateParRef, PROFMCode) [ Unique ];

/// 索引- 职务子类（父表）-描述
Index IndexParRefDesc On (SubCateParRef, PROFMDesc) [ Unique ];

Storage Default
{
<Data name="HOSProfMajorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFMCode</Value>
</Value>
<Value name="3">
<Value>PROFMDesc</Value>
</Value>
<Value name="4">
<Value>PROFMSource</Value>
</Value>
<Value name="5">
<Value>PROFMActivity</Value>
</Value>
<Value name="6">
<Value>PROFMStartDate</Value>
</Value>
<Value name="7">
<Value>PROFMEndDate</Value>
</Value>
<Value name="8">
<Value>PROFMCreateDate</Value>
</Value>
<Value name="9">
<Value>PROFMCreateTime</Value>
</Value>
<Value name="10">
<Value>PROFMCreateUser</Value>
</Value>
<Value name="11">
<Value>PROFMSeqNo</Value>
</Value>
<Value name="12">
<Value>PROFMLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>PROFMLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>PROFMLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>PROFMPYCode</Value>
</Value>
<Value name="16">
<Value>PROFMWBCode</Value>
</Value>
<Value name="17">
<Value>PROFMMark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildMajor")</DataLocation>
<DefaultData>HOSProfMajorDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfSubCateC("ChildMajor")</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfMajorI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfMajorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
