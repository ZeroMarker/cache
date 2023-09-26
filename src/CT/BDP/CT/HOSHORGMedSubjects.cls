/// 描述:医疗机构诊疗科目
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSHORGMedSubjects Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_HORGMedSubjects ]
{

/// 医疗机构代码 + 医疗机构科室代码 联合主键？
/// 医疗机构代码
Property HORGMSORGCode As User.CTRefClin [ Required, SqlColumnNumber = 2, SqlFieldName = HORGMS__ORGCode ];

/// 医疗机构科室代码-外键  Required, 删除2022-12-14
Property HORGMSCode As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = HORGMS_Code ];

/// 一级诊疗科目代码
Property HORGMSMSUBCode As CT.BDP.CT.HOSMedSubjects [ SqlColumnNumber = 4, SqlFieldName = HORGMS_MSUBCode ];

/// 二级诊疗科目代码
Property HORGMSMSPECCode As CT.BDP.CT.HOSMedSpecialties [ SqlColumnNumber = 5, SqlFieldName = HORGMS_MSPECCode ];

/// 三级诊疗科目代码
Property HORGMSMSPECICode As CT.BDP.CT.HOSMedSpecItems [ SqlColumnNumber = 6, SqlFieldName = HORGMS_MSPECICode ];

/// 分类来源
Property HORGMSSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HORGMS_Source ];

/// 是否有效(Y/N)
Property HORGMSActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = HORGMS_Activity ];

/// 开始日期
Property HORGMSStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = HORGMS_StartDate ];

/// 结束日期
Property HORGMSEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = HORGMS_EndDate ];

/// 系统创建日期
Property HORGMSCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = HORGMS_CreateDate ];

/// 系统创建时间
Property HORGMSCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = HORGMS_CreateTime ];

/// 系统创建人
Property HORGMSCreateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = HORGMS_CreateUser ];

/// 系统排序号
Property HORGMSSeqNo As %Float [ SqlColumnNumber = 14, SqlFieldName = HORGMS_SeqNo ];

/// 系统最后更新日期
Property HORGMSLastUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = HORGMS_LastUpdateDate ];

/// 系统最后更新时间
Property HORGMSLastUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = HORGMS_LastUpdateTime ];

/// 系统最新更新人
Property HORGMSLastUpdateUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = HORGMS_LastUpdateUser ];

/// 拼音码
Property HORGMSPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = HORGMS_PYCode ];

/// 五笔码
Property HORGMSWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = HORGMS_WBCode ];

/// 备注
Property HORGMSMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = HORGMS_Mark ];

/// 索引-医疗机构代码
Index IndexORGCode On HORGMSORGCode;

/// 索引-医疗机构科室代码 -外键
Index IndexDesc On HORGMSCode;

/// 索引-医疗机构代码+医疗机构科室代码  // [ Unique ]
Index IndexMain On (HORGMSORGCode, HORGMSCode);

/// 索引-系统排序号
Index IndexSeqNo On HORGMSSeqNo;

/// 索引-一级诊疗科目代码
Index IndexMSUBCode On HORGMSMSUBCode;

/// 索引-二级诊疗科目代码
Index IndexMSPECCode On HORGMSMSPECCode;

/// 索引-三级诊疗科目代码
Index IndexMSPECICode On HORGMSMSPECICode;

Storage Default
{
<Data name="HOSHORGMedSubjectsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HORGMSORGCode</Value>
</Value>
<Value name="3">
<Value>HORGMSCode</Value>
</Value>
<Value name="4">
<Value>HORGMSMSUBCode</Value>
</Value>
<Value name="5">
<Value>HORGMSMSPECCode</Value>
</Value>
<Value name="6">
<Value>HORGMSMSPECICode</Value>
</Value>
<Value name="7">
<Value>HORGMSSource</Value>
</Value>
<Value name="8">
<Value>HORGMSActivity</Value>
</Value>
<Value name="9">
<Value>HORGMSStartDate</Value>
</Value>
<Value name="10">
<Value>HORGMSEndDate</Value>
</Value>
<Value name="11">
<Value>HORGMSCreateDate</Value>
</Value>
<Value name="12">
<Value>HORGMSCreateTime</Value>
</Value>
<Value name="13">
<Value>HORGMSCreateUser</Value>
</Value>
<Value name="14">
<Value>HORGMSSeqNo</Value>
</Value>
<Value name="15">
<Value>HORGMSLastUpdateDate</Value>
</Value>
<Value name="16">
<Value>HORGMSLastUpdateTime</Value>
</Value>
<Value name="17">
<Value>HORGMSLastUpdateUser</Value>
</Value>
<Value name="18">
<Value>HORGMSPYCode</Value>
</Value>
<Value name="19">
<Value>HORGMSWBCode</Value>
</Value>
<Value name="20">
<Value>HORGMSMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSHORGMedSubjectsD</DataLocation>
<DefaultData>HOSHORGMedSubjectsDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSHORGMedSubjectsD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSHORGMedSubjectsI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSHORGMedSubjectsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
