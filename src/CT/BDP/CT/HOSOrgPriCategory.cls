/// 描述:机构分类大类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgPriCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgPriCategory ]
{

///  机构分类中类字典（子表）
Relationship ChildOrgSecCategory As CT.BDP.CT.HOSOrgSecCategory [ Cardinality = children, Inverse = PriCategoryParRef ];

/// 机构大类代码
Property OPCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OPC_Code ];

/// 机构大类名称
Property OPCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OPC_Desc ];

/// 分类来源
Property OPCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OPC_Source ];

/// 是否有效(Y/N)
Property OPCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = OPC_Activity ];

/// 开始日期
Property OPCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = OPC_StartDate ];

/// 结束日期
Property OPCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OPC_EndDate ];

/// 系统创建日期
Property OPCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = OPC_CreateDate ];

/// 系统创建时间
Property OPCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = OPC_CreateTime ];

/// 系统创建人
Property OPCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = OPC_CreateUser ];

/// 系统排序号
Property OPCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = OPC_SeqNo ];

/// 系统最后更新日期
Property OPCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = OPC_LastUpdateDate ];

/// 系统最后更新时间
Property OPCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OPC_LastUpdateTime ];

/// 系统最新更新人
Property OPCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OPC_LastUpdateUser ];

/// 拼音码
Property OPCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OPC_PYCode ];

/// 五笔码
Property OPCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OPC_WBCode ];

/// 备注
Property OPCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OPC_Mark ];

/// 索引-代码
Index IndexCode On OPCCode [ Unique ];

/// 索引-名称
Index IndexDesc On OPCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On OPCSeqNo;

Storage Default
{
<Data name="HOSOrgPriCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPCCode</Value>
</Value>
<Value name="3">
<Value>OPCDesc</Value>
</Value>
<Value name="4">
<Value>OPCSource</Value>
</Value>
<Value name="5">
<Value>OPCActivity</Value>
</Value>
<Value name="6">
<Value>OPCStartDate</Value>
</Value>
<Value name="7">
<Value>OPCEndDate</Value>
</Value>
<Value name="8">
<Value>OPCCreateDate</Value>
</Value>
<Value name="9">
<Value>OPCCreateTime</Value>
</Value>
<Value name="10">
<Value>OPCCreateUser</Value>
</Value>
<Value name="11">
<Value>OPCSeqNo</Value>
</Value>
<Value name="12">
<Value>OPCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>OPCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>OPCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>OPCPYCode</Value>
</Value>
<Value name="16">
<Value>OPCWBCode</Value>
</Value>
<Value name="17">
<Value>OPCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgPriCategoryD</DataLocation>
<DefaultData>HOSOrgPriCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgPriCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgPriCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgPriCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
