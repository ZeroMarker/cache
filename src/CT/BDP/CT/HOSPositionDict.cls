/// 描述:职位字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPositionDict Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PositionDict ]
{

/// 职位代码
Property POSCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = POSC_Code ];

/// 职位名称
Property POSCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = POSC_Desc ];

/// 是否有效(Y/N)
Property POSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = POSC_Activity ];

/// 开始日期
Property POSCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = POSC_StartDate ];

/// 结束日期
Property POSCEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = POSC_EndDate ];

/// 系统创建日期
Property POSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = POSC_CreateDate ];

/// 系统创建时间
Property POSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = POSC_CreateTime ];

/// 系统创建人
Property POSCCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = POSC_CreateUser ];

/// 系统排序号
Property POSCSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = POSC_SeqNo ];

/// 系统最后更新日期
Property POSCLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = POSC_LastUpdateDate ];

/// 系统最后更新时间
Property POSCLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = POSC_LastUpdateTime ];

/// 系统最新更新人
Property POSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = POSC_LastUpdateUser ];

/// 拼音码
Property POSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = POSC_PYCode ];

/// 五笔码
Property POSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = POSC_WBCode ];

/// 备注
Property POSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = POSC_Mark ];

/// 索引-职位代码
Index IndexCode On POSCCode;

/// 索引-职位名称
Index IndexDesc On POSCDesc;

/// 索引-系统排序号
Index IndexSeqNo On POSCSeqNo;

Storage Default
{
<Data name="HOSPositionDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POSCCode</Value>
</Value>
<Value name="3">
<Value>POSCDesc</Value>
</Value>
<Value name="4">
<Value>POSCActivity</Value>
</Value>
<Value name="5">
<Value>POSCStartDate</Value>
</Value>
<Value name="6">
<Value>POSCEndDate</Value>
</Value>
<Value name="7">
<Value>POSCCreateDate</Value>
</Value>
<Value name="8">
<Value>POSCCreateTime</Value>
</Value>
<Value name="9">
<Value>POSCCreateUser</Value>
</Value>
<Value name="10">
<Value>POSCSeqNo</Value>
</Value>
<Value name="11">
<Value>POSCLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>POSCLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>POSCLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>POSCPYCode</Value>
</Value>
<Value name="15">
<Value>POSCWBCode</Value>
</Value>
<Value name="16">
<Value>POSCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPositionDictD</DataLocation>
<DefaultData>HOSPositionDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPositionDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPositionDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPositionDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
