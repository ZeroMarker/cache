/// 描述:医疗机构三级诊疗科目字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSMedSpecItems Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_MedSpecItems ]
{

/// 三级诊疗科目代码
Property MSPECICode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MSPECI_Code ];

/// 三级诊疗科目名称
Property MSPECIDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MSPECI_Desc ];

/// 二级诊疗科目-外键
Property MSPECIMSPECCode As CT.BDP.CT.HOSMedSpecialties [ SqlColumnNumber = 4, SqlFieldName = MSPECI_MSPECCode ];

/// 分类来源
Property MSPECISource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MSPECI_Source ];

/// 是否有效(Y/N)
Property MSPECIActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = MSPECI_Activity ];

/// 开始日期
Property MSPECIStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = MSPECI_StartDate ];

/// 结束日期
Property MSPECIEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MSPECI_EndDate ];

/// 系统创建日期
Property MSPECICreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = MSPECI_CreateDate ];

/// 系统创建时间
Property MSPECICreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = MSPECI_CreateTime ];

/// 系统创建人
Property MSPECICreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = MSPECI_CreateUser ];

/// 系统排序号
Property MSPECISeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = MSPECI_SeqNo ];

/// 系统最后更新日期
Property MSPECILastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = MSPECI_LastUpdateDate ];

/// 系统最后更新时间
Property MSPECILastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = MSPECI_LastUpdateTime ];

/// 系统最新更新人
Property MSPECILastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = MSPECI_LastUpdateUser ];

/// 拼音码
Property MSPECIPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MSPECI_PYCode ];

/// 五笔码
Property MSPECIWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = MSPECI_WBCode ];

/// 备注
Property MSPECIMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MSPECI_Mark ];

/// 索引-代码
Index IndexCode On MSPECICode [ Unique ];

/// 索引-名称
Index IndexDesc On MSPECIDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On MSPECISeqNo;

/// 索引-二级诊疗科目-外键
Index IndexMSPECCode On MSPECIMSPECCode;

Storage Default
{
<Data name="HOSMedSpecItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSPECICode</Value>
</Value>
<Value name="3">
<Value>MSPECIDesc</Value>
</Value>
<Value name="4">
<Value>MSPECIMSPECCode</Value>
</Value>
<Value name="5">
<Value>MSPECISource</Value>
</Value>
<Value name="6">
<Value>MSPECIActivity</Value>
</Value>
<Value name="7">
<Value>MSPECIStartDate</Value>
</Value>
<Value name="8">
<Value>MSPECIEndDate</Value>
</Value>
<Value name="9">
<Value>MSPECICreateDate</Value>
</Value>
<Value name="10">
<Value>MSPECICreateTime</Value>
</Value>
<Value name="11">
<Value>MSPECICreateUser</Value>
</Value>
<Value name="12">
<Value>MSPECISeqNo</Value>
</Value>
<Value name="13">
<Value>MSPECILastUpdateDate</Value>
</Value>
<Value name="14">
<Value>MSPECILastUpdateTime</Value>
</Value>
<Value name="15">
<Value>MSPECILastUpdateUser</Value>
</Value>
<Value name="16">
<Value>MSPECIPYCode</Value>
</Value>
<Value name="17">
<Value>MSPECIWBCode</Value>
</Value>
<Value name="18">
<Value>MSPECIMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSMedSpecItemsD</DataLocation>
<DefaultData>HOSMedSpecItemsDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSMedSpecItemsD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSMedSpecItemsI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSMedSpecItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
