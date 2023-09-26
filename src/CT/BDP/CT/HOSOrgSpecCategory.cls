/// 描述:组织机构专业分类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgSpecCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgSpecCategory ]
{

/// 组织机构专业分类代码
Property ORGSPCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGSPC_Code ];

/// 组织机构专业分类名称
Property ORGSPCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGSPC_Desc ];

/// 组织机构小类-外键
Property ORGSPCORGSPCCode As CT.BDP.CT.HOSOrgMinCategory [ SqlColumnNumber = 4, SqlFieldName = ORGSPCORGSPCCode ];

/// 分类来源
Property ORGSPCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORGSPC_Source ];

/// 是否有效(Y/N)
Property ORGSPCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = ORGSPC_Activity ];

/// 开始日期
Property ORGSPCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORGSPC_StartDate ];

/// 结束日期
Property ORGSPCEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ORGSPC_EndDate ];

/// 系统创建日期
Property ORGSPCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = ORGSPC_CreateDate ];

/// 系统创建时间
Property ORGSPCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = ORGSPC_CreateTime ];

/// 系统创建人
Property ORGSPCCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORGSPC_CreateUser ];

/// 系统排序号
Property ORGSPCSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = ORGSPC_SeqNo ];

/// 系统最后更新日期
Property ORGSPCLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ORGSPC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGSPCLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ORGSPC_LastUpdateTime ];

/// 系统最新更新人
Property ORGSPCLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = ORGSPC_LastUpdateUser ];

/// 拼音码
Property ORGSPCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGSPC_PYCode ];

/// 五笔码
Property ORGSPCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGSPC_WBCode ];

/// 备注
Property ORGSPCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ORGSPC_Mark ];

/// 索引-代码
Index IndexCode On ORGSPCCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGSPCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGSPCSeqNo;

/// 索引-组织机构分类小类-外键
Index IndexMinCategory On ORGSPCORGSPCCode;

Storage Default
{
<Data name="HOSOrgSpecCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGSPCCode</Value>
</Value>
<Value name="3">
<Value>ORGSPCDesc</Value>
</Value>
<Value name="4">
<Value>ORGSPCORGSPCCode</Value>
</Value>
<Value name="5">
<Value>ORGSPCSource</Value>
</Value>
<Value name="6">
<Value>ORGSPCActivity</Value>
</Value>
<Value name="7">
<Value>ORGSPCStartDate</Value>
</Value>
<Value name="8">
<Value>ORGSPCEndDate</Value>
</Value>
<Value name="9">
<Value>ORGSPCCreateDate</Value>
</Value>
<Value name="10">
<Value>ORGSPCCreateTime</Value>
</Value>
<Value name="11">
<Value>ORGSPCCreateUser</Value>
</Value>
<Value name="12">
<Value>ORGSPCSeqNo</Value>
</Value>
<Value name="13">
<Value>ORGSPCLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>ORGSPCLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>ORGSPCLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>ORGSPCPYCode</Value>
</Value>
<Value name="17">
<Value>ORGSPCWBCode</Value>
</Value>
<Value name="18">
<Value>ORGSPCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgSpecCategoryD</DataLocation>
<DefaultData>HOSOrgSpecCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgSpecCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgSpecCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgSpecCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
