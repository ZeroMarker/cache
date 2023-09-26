/// 描述:医疗机构二级诊疗科目字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSMedSpecialties Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_MedSpecialties ]
{

/// 二级诊疗科目代码
Property MSPECCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MSPEC_Code ];

/// 二级诊疗科目名称
Property MSPECDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MSPEC_Desc ];

/// 一级诊疗科目-外键
Property MSPECMSUBCode As CT.BDP.CT.HOSMedSubjects [ SqlColumnNumber = 4, SqlFieldName = MSPEC_MSUBCode ];

/// 分类来源
Property MSPECSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MSPEC_Source ];

/// 是否有效(Y/N)
Property MSPECActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = MSPEC_Activity ];

/// 开始日期
Property MSPECStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = MSPEC_StartDate ];

/// 结束日期
Property MSPECEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MSPEC_EndDate ];

/// 系统创建日期
Property MSPECCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = MSPEC_CreateDate ];

/// 系统创建时间
Property MSPECCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = MSPEC_CreateTime ];

/// 系统创建人
Property MSPECCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = MSPEC_CreateUser ];

/// 系统排序号
Property MSPECSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = MSPEC_SeqNo ];

/// 系统最后更新日期
Property MSPECLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = MSPEC_LastUpdateDate ];

/// 系统最后更新时间
Property MSPECLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = MSPEC_LastUpdateTime ];

/// 系统最新更新人
Property MSPECLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = MSPEC_LastUpdateUser ];

/// 拼音码
Property MSPECPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MSPEC_PYCode ];

/// 五笔码
Property MSPECWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = MSPEC_WBCode ];

/// 备注
Property MSPECMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MSPEC_Mark ];

/// 索引-代码
Index IndexCode On MSPECCode [ Unique ];

/// 索引-名称
Index IndexDesc On MSPECDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On MSPECSeqNo;

/// 索引-一级诊疗科目-外键
Index IndexMSUBCode On MSPECMSUBCode;

Storage Default
{
<Data name="HOSMedSpecialtiesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSPECCode</Value>
</Value>
<Value name="3">
<Value>MSPECDesc</Value>
</Value>
<Value name="4">
<Value>MSPECMSUBCode</Value>
</Value>
<Value name="5">
<Value>MSPECSource</Value>
</Value>
<Value name="6">
<Value>MSPECActivity</Value>
</Value>
<Value name="7">
<Value>MSPECStartDate</Value>
</Value>
<Value name="8">
<Value>MSPECEndDate</Value>
</Value>
<Value name="9">
<Value>MSPECCreateDate</Value>
</Value>
<Value name="10">
<Value>MSPECCreateTime</Value>
</Value>
<Value name="11">
<Value>MSPECCreateUser</Value>
</Value>
<Value name="12">
<Value>MSPECSeqNo</Value>
</Value>
<Value name="13">
<Value>MSPECLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>MSPECLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>MSPECLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>MSPECPYCode</Value>
</Value>
<Value name="17">
<Value>MSPECWBCode</Value>
</Value>
<Value name="18">
<Value>MSPECMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSMedSpecialtiesD</DataLocation>
<DefaultData>HOSMedSpecialtiesDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSMedSpecialtiesD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSMedSpecialtiesI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSMedSpecialtiesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
