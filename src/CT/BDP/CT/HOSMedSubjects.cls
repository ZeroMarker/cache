/// 描述:医疗机构一级诊疗科目字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSMedSubjects Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_MedSubjects ]
{

/// 一级诊疗科目代码
Property MSUBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MSUB_Code ];

/// 一级诊疗科目名称
Property MSUBDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MSUB_Desc ];

/// 分类来源
Property MSUBSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MSUB_Source ];

/// 是否有效(Y/N)
Property MSUBActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = MSUB_Activity ];

/// 开始日期
Property MSUBStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = MSUB_StartDate ];

/// 结束日期
Property MSUBEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = MSUB_EndDate ];

/// 系统创建日期
Property MSUBCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = MSUB_CreateDate ];

/// 系统创建时间
Property MSUBCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = MSUB_CreateTime ];

/// 系统创建人
Property MSUBCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = MSUB_CreateUser ];

/// 系统排序号
Property MSUBSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = MSUB_SeqNo ];

/// 系统最后更新日期
Property MSUBLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = MSUB_LastUpdateDate ];

/// 系统最后更新时间
Property MSUBLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = MSUB_LastUpdateTime ];

/// 系统最新更新人
Property MSUBLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = MSUB_LastUpdateUser ];

/// 拼音码
Property MSUBPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = MSUB_PYCode ];

/// 五笔码
Property MSUBWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MSUB_WBCode ];

/// 备注
Property MSUBMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = MSUB_Mark ];

/// 索引-代码
Index IndexCode On MSUBCode [ Unique ];

/// 索引-名称
Index IndexDesc On MSUBDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On MSUBSeqNo;

Storage Default
{
<Data name="HOSMedSubjectsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSUBCode</Value>
</Value>
<Value name="3">
<Value>MSUBDesc</Value>
</Value>
<Value name="4">
<Value>MSUBSource</Value>
</Value>
<Value name="5">
<Value>MSUBActivity</Value>
</Value>
<Value name="6">
<Value>MSUBStartDate</Value>
</Value>
<Value name="7">
<Value>MSUBEndDate</Value>
</Value>
<Value name="8">
<Value>MSUBCreateDate</Value>
</Value>
<Value name="9">
<Value>MSUBCreateTime</Value>
</Value>
<Value name="10">
<Value>MSUBCreateUser</Value>
</Value>
<Value name="11">
<Value>MSUBSeqNo</Value>
</Value>
<Value name="12">
<Value>MSUBLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>MSUBLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>MSUBLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>MSUBPYCode</Value>
</Value>
<Value name="16">
<Value>MSUBWBCode</Value>
</Value>
<Value name="17">
<Value>MSUBMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSMedSubjectsD</DataLocation>
<DefaultData>HOSMedSubjectsDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSMedSubjectsD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSMedSubjectsI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSMedSubjectsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
