/// 描述:流程中心词
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSFlowHeadWord Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_FlowHeadWord ]
{

/// 流程中心词代码
Property FHWCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2, SqlFieldName = FHW_Code ];

/// 流程中心词名称
Property FHWDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = FHW_Desc ];

/// 业务域编码
Property FHWDomainCode As CT.BDP.CT.HOSBusiDomain [ SqlColumnNumber = 4, SqlFieldName = FHW_DomainCode ];

/// 是否有效(Y/N)
Property FHWActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = FHW_Activity ];

/// 开始日期
Property FHWStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = FHW_StartDate ];

/// 结束日期
Property FHWEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = FHW_EndDate ];

/// 系统创建日期
Property FHWCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = FHW_CreateDate ];

/// 系统创建时间
Property FHWCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = FHW_CreateTime ];

/// 系统创建人
Property FHWCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = FHW_CreateUser ];

/// 系统排序号
Property FHWSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = FHW_SeqNo ];

/// 系统最后更新日期
Property FHWLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = FHW_LastUpdateDate ];

/// 系统最后更新时间
Property FHWLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = FHW_LastUpdateTime ];

/// 系统最新更新人
Property FHWLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = FHW_LastUpdateUser ];

/// 拼音码
Property FHWPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = FHW_PYCode ];

/// 五笔码
Property FHWWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = FHW_WBCode ];

/// 备注
Property FHWMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = FHW_Mark ];

/// 索引-流程中心词代码
Index IndexFHWCode On FHWCode;

/// 索引-流程中心词名称
Index IndexFHWDesc On FHWDesc;

/// 索引-业务域编码
Index IndexDomainCode On FHWDomainCode;

Storage Default
{
<Data name="HOSFlowHeadWordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FHWCode</Value>
</Value>
<Value name="3">
<Value>FHWDesc</Value>
</Value>
<Value name="4">
<Value>FHWDomainCode</Value>
</Value>
<Value name="5">
<Value>FHWActivity</Value>
</Value>
<Value name="6">
<Value>FHWStartDate</Value>
</Value>
<Value name="7">
<Value>FHWEndDate</Value>
</Value>
<Value name="8">
<Value>FHWCreateDate</Value>
</Value>
<Value name="9">
<Value>FHWCreateTime</Value>
</Value>
<Value name="10">
<Value>FHWCreateUser</Value>
</Value>
<Value name="11">
<Value>FHWSeqNo</Value>
</Value>
<Value name="12">
<Value>FHWLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>FHWLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>FHWLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>FHWPYCode</Value>
</Value>
<Value name="16">
<Value>FHWWBCode</Value>
</Value>
<Value name="17">
<Value>FHWMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSFlowHeadWordD</DataLocation>
<DefaultData>HOSFlowHeadWordDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSFlowHeadWordD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSFlowHeadWordI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSFlowHeadWordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// 业务域编码-索引

}
