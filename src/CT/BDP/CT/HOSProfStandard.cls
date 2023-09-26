/// 描述:职务标准代码
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfStandard Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfStandard ]
{

/// 职务标准代码
Property PROFSCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFS_Code ];

/// 职务标准名称
Property PROFSDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFS_Desc ];

/// 是否有效(Y/N)
Property PROFSActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PROFS_Activity ];

/// 开始日期
Property PROFSStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PROFS_StartDate ];

/// 结束日期
Property PROFSEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PROFS_EndDate ];

/// 系统创建日期
Property PROFSCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PROFS_CreateDate ];

/// 系统创建时间
Property PROFSCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PROFS_CreateTime ];

/// 系统创建人
Property PROFSCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PROFS_CreateUser ];

/// 系统排序号
Property PROFSSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PROFS_SeqNo ];

/// 系统最后更新日期
Property PROFSLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PROFS_LastUpdateDate ];

/// 系统最后更新时间
Property PROFSLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PROFS_LastUpdateTime ];

/// 系统最新更新人
Property PROFSLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PROFS_LastUpdateUser ];

/// 拼音码
Property PROFSPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PROFS_PYCode ];

/// 五笔码
Property PROFSWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFS_WBCode ];

/// 备注
Property PROFSMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFS_Mark ];

/// 索引-代码
Index IndexCode On PROFSCode [ Unique ];

/// 索引-名称
Index IndexDesc On PROFSDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On PROFSSeqNo;

Storage Default
{
<Data name="HOSProfStandardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFSCode</Value>
</Value>
<Value name="3">
<Value>PROFSDesc</Value>
</Value>
<Value name="4">
<Value>PROFSActivity</Value>
</Value>
<Value name="5">
<Value>PROFSStartDate</Value>
</Value>
<Value name="6">
<Value>PROFSEndDate</Value>
</Value>
<Value name="7">
<Value>PROFSCreateDate</Value>
</Value>
<Value name="8">
<Value>PROFSCreateTime</Value>
</Value>
<Value name="9">
<Value>PROFSCreateUser</Value>
</Value>
<Value name="10">
<Value>PROFSSeqNo</Value>
</Value>
<Value name="11">
<Value>PROFSLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>PROFSLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>PROFSLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>PROFSPYCode</Value>
</Value>
<Value name="15">
<Value>PROFSWBCode</Value>
</Value>
<Value name="16">
<Value>PROFSMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfStandardD</DataLocation>
<DefaultData>HOSProfStandardDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfStandardD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfStandardI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfStandardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
