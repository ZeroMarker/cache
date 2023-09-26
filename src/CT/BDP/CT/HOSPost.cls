/// 描述:业务岗位
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPost Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Post ]
{

/// 业务岗位代码
Property POSTCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = POST_Code ];

/// 业务岗位名称
Property POSTDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = POST_Desc ];

/// 业务单元代码-外键
Property POSTBUCode As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = POST_BUCode ];

/// 岗位字典代码-外键
Property POSTPOSTCCode As CT.BDP.CT.HOSPostDict [ Required, SqlColumnNumber = 5, SqlFieldName = POST_POSTCCode ];

/// 是否有效(Y/N)
Property POSTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = POST_Activity ];

/// 开始日期
Property POSTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = POST_StartDate ];

/// 结束日期
Property POSTEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = POST_EndDate ];

/// 系统创建日期
Property POSTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = POST_CreateDate ];

/// 系统创建时间
Property POSTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = POST_CreateTime ];

/// 系统创建人
Property POSTCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = POST_CreateUser ];

/// 系统排序号
Property POSTSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = POST_SeqNo ];

/// 系统最后更新日期
Property POSTLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = POST_LastUpdateDate ];

/// 系统最后更新时间
Property POSTLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = POST_LastUpdateTime ];

/// 系统最新更新人
Property POSTLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = POST_LastUpdateUser ];

/// 拼音码
Property POSTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = POST_PYCode ];

/// 五笔码
Property POSTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = POST_WBCode ];

/// 备注
Property POSTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = POST_Mark ];

/// 索引-代码
Index IndexCode On POSTCode [ Unique ];

/// 索引-名称
Index IndexDesc On POSTDesc [ Unique ];

/// 索引-业务单元-外键
Index IndexBUCode On POSTBUCode;

/// 索引-岗位字典-外键
Index IndexPOSTCCode On POSTPOSTCCode;

/// 索引-系统排序号
Index IndexSeqNo On POSTSeqNo;

Storage Default
{
<Data name="HOSPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POSTCode</Value>
</Value>
<Value name="3">
<Value>POSTDesc</Value>
</Value>
<Value name="4">
<Value>POSTBUCode</Value>
</Value>
<Value name="5">
<Value>POSTPOSTCCode</Value>
</Value>
<Value name="6">
<Value>POSTActivity</Value>
</Value>
<Value name="7">
<Value>POSTStartDate</Value>
</Value>
<Value name="8">
<Value>POSTEndDate</Value>
</Value>
<Value name="9">
<Value>POSTCreateDate</Value>
</Value>
<Value name="10">
<Value>POSTCreateTime</Value>
</Value>
<Value name="11">
<Value>POSTCreateUser</Value>
</Value>
<Value name="12">
<Value>POSTSeqNo</Value>
</Value>
<Value name="13">
<Value>POSTLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>POSTLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>POSTLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>POSTPYCode</Value>
</Value>
<Value name="17">
<Value>POSTWBCode</Value>
</Value>
<Value name="18">
<Value>POSTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPostD</DataLocation>
<DefaultData>HOSPostDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPostD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPostI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
