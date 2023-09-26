/// 描述:流程岗位与业务岗位关系
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSProcPostRelPost Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProcPostRelPost ]
{

/// 流程岗位代码
Property PPRPProcPostCode As CT.BDP.CT.HOSProcPost [ Required, SqlColumnNumber = 2, SqlFieldName = PPRP_ProcPostCode ];

/// 业务岗位代码
Property PPRPPostCode As CT.BDP.CT.HOSPost [ Required, SqlColumnNumber = 3, SqlFieldName = PPRP_PostCode ];

/// 是否有效(Y/N)
Property PPRPActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PPRP_Activity ];

/// 开始日期
Property PPRPStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PPRP_StartDate ];

/// 结束日期
Property PPRPEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PPRP_EndDate ];

/// 系统创建日期
Property PPRPCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PPRP_CreateDate ];

/// 系统创建时间
Property PPRPCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PPRP_CreateTime ];

/// 系统创建人
Property PPRPCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PPRP_CreateUser ];

/// 系统排序号
Property PPRPSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PPRP_SeqNo ];

/// 系统最后更新日期
Property PPRPLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PPRP_LastUpdateDate ];

/// 系统最后更新时间
Property PPRPLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PPRP_LastUpdateTime ];

/// 系统最新更新人
Property PPRPLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PPRP_LastUpdateUser ];

/// 拼音码
Property PPRPPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PPRP_PYCode ];

/// 五笔码
Property PPRPWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PPRP_WBCode ];

/// 备注
Property PPRPMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PPRP_Mark ];

/// 索引-流程岗位+业务岗位外键
Index IndexProcPostCode On (PPRPProcPostCode, PPRPPostCode);

/// 索引-流程岗位
Index IndexPPRPProcPost On PPRPProcPostCode;

/// 索引-业务岗位
Index IndexPPRPPostCode On PPRPPostCode;

Storage Default
{
<Data name="HOSProcPostRelPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PPRPProcPostCode</Value>
</Value>
<Value name="3">
<Value>PPRPPostCode</Value>
</Value>
<Value name="4">
<Value>PPRPActivity</Value>
</Value>
<Value name="5">
<Value>PPRPStartDate</Value>
</Value>
<Value name="6">
<Value>PPRPEndDate</Value>
</Value>
<Value name="7">
<Value>PPRPCreateDate</Value>
</Value>
<Value name="8">
<Value>PPRPCreateTime</Value>
</Value>
<Value name="9">
<Value>PPRPCreateUser</Value>
</Value>
<Value name="10">
<Value>PPRPSeqNo</Value>
</Value>
<Value name="11">
<Value>PPRPLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>PPRPLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>PPRPLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>PPRPPYCode</Value>
</Value>
<Value name="15">
<Value>PPRPWBCode</Value>
</Value>
<Value name="16">
<Value>PPRPMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProcPostRelPostD</DataLocation>
<DefaultData>HOSProcPostRelPostDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProcPostRelPostD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProcPostRelPostI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProcPostRelPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
