/// 描述:岗位字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPostDict Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PostDict ]
{

/// 岗位代码
Property POSTCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = POSTC_Code ];

/// 岗位名称
Property POSTCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = POSTC_Desc ];

/// 业务域代码
Property POSTCDomainCode As CT.BDP.CT.HOSBusiDomain [ SqlColumnNumber = 4, SqlFieldName = POSTC_DomainCode ];

/// 职位字典代码
Property POSTCPOSCCode As CT.BDP.CT.HOSPositionDict [ SqlColumnNumber = 5, SqlFieldName = POSTC_POSCCode ];

/// 职务字典代码
Property POSTCPROFTCode As CT.BDP.CT.HOSProfTitleDict [ SqlColumnNumber = 6, SqlFieldName = POSTC_PROFTCode ];

/// 岗位中心词
Property POSTCPHWCode As CT.BDP.CT.HOSPostHeadWord [ SqlColumnNumber = 7, SqlFieldName = POSTC_PHWCode ];

/// 流程中心词
Property POSTCFHWCode As CT.BDP.CT.HOSFlowHeadWord [ SqlColumnNumber = 8, SqlFieldName = POSTC_FHWCode ];

/// 岗位简称
Property POSTCShortDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = POSTC_ShortDesc ];

/// 岗位类型
Property POSTCType As CT.BDP.CT.HOSPostType [ SqlColumnNumber = 10, SqlFieldName = POSTC_Type ];

/// 是否有效(Y/N)
Property POSTCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 11, SqlFieldName = POSTC_Activity ];

/// 开始日期
Property POSTCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = POSTC_StartDate ];

/// 结束日期
Property POSTCEndDate As %Date [ SqlColumnNumber = 13, SqlFieldName = POSTC_EndDate ];

/// 系统创建日期
Property POSTCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = POSTC_CreateDate ];

/// 系统创建时间
Property POSTCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 15, SqlFieldName = POSTC_CreateTime ];

/// 系统创建人
Property POSTCCreateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = POSTC_CreateUser ];

/// 系统排序号
Property POSTCSeqNo As %Float [ SqlColumnNumber = 17, SqlFieldName = POSTC_SeqNo ];

/// 系统最后更新日期
Property POSTCLastUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = POSTC_LastUpdateDate ];

/// 系统最后更新时间
Property POSTCLastUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = POSTC_LastUpdateTime ];

/// 系统最新更新人
Property POSTCLastUpdateUser As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = POSTC_LastUpdateUser ];

/// 拼音码
Property POSTCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = POSTC_PYCode ];

/// 五笔码
Property POSTCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = POSTC_WBCode ];

/// 备注
Property POSTCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = POSTC_Mark ];

/// 索引-岗位代码
Index IndexCode On POSTCCode;

/// 索引-岗位名称
Index IndexDesc On POSTCDesc;

/// 索引-系统排序号
Index IndexSeqNo On POSTCSeqNo;

/// 索引-业务域
Index IndexDomainCode On POSTCDomainCode;

/// 索引-职位字典代码
Index IndexPOSCCode On POSTCPOSCCode;

/// 索引-职务字典代码
Index IndexPROFTCode On POSTCPROFTCode;

/// 索引-岗位中心词
Index IndexPHWCode On POSTCPHWCode;

/// 索引-流程中心词
Index IndexFHWCode On POSTCFHWCode;

/// 索引-岗位类型
Index IndexType On POSTCType;

Storage Default
{
<Data name="HOSPostDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POSTCCode</Value>
</Value>
<Value name="3">
<Value>POSTCDesc</Value>
</Value>
<Value name="4">
<Value>POSTCDomainCode</Value>
</Value>
<Value name="5">
<Value>POSTCPOSCCode</Value>
</Value>
<Value name="6">
<Value>POSTCPROFTCode</Value>
</Value>
<Value name="7">
<Value>POSTCPHWCode</Value>
</Value>
<Value name="8">
<Value>POSTCFHWCode</Value>
</Value>
<Value name="9">
<Value>POSTCShortDesc</Value>
</Value>
<Value name="10">
<Value>POSTCType</Value>
</Value>
<Value name="11">
<Value>POSTCActivity</Value>
</Value>
<Value name="12">
<Value>POSTCStartDate</Value>
</Value>
<Value name="13">
<Value>POSTCEndDate</Value>
</Value>
<Value name="14">
<Value>POSTCCreateDate</Value>
</Value>
<Value name="15">
<Value>POSTCCreateTime</Value>
</Value>
<Value name="16">
<Value>POSTCCreateUser</Value>
</Value>
<Value name="17">
<Value>POSTCSeqNo</Value>
</Value>
<Value name="18">
<Value>POSTCLastUpdateDate</Value>
</Value>
<Value name="19">
<Value>POSTCLastUpdateTime</Value>
</Value>
<Value name="20">
<Value>POSTCLastUpdateUser</Value>
</Value>
<Value name="21">
<Value>POSTCPYCode</Value>
</Value>
<Value name="22">
<Value>POSTCWBCode</Value>
</Value>
<Value name="23">
<Value>POSTCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPostDictD</DataLocation>
<DefaultData>HOSPostDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPostDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPostDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPostDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
