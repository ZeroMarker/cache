/// 描述:岗位中心词
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSPostHeadWord Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PostHeadWord ]
{

/// 岗位中心词代码
Property PHWCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2, SqlFieldName = PHW_Code ];

/// 岗位中心词名称
Property PHWDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PHW_Desc ];

/// 业务域编码
Property PHWDomainCode As CT.BDP.CT.HOSBusiDomain [ SqlColumnNumber = 4, SqlFieldName = PHW_DomainCode ];

/// 是否有效(Y/N)
Property PHWActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = PHW_Activity ];

/// 开始日期
Property PHWStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PHW_StartDate ];

/// 结束日期
Property PHWEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PHW_EndDate ];

/// 系统创建日期
Property PHWCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PHW_CreateDate ];

/// 系统创建时间
Property PHWCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = PHW_CreateTime ];

/// 系统创建人
Property PHWCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PHW_CreateUser ];

/// 系统排序号
Property PHWSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = PHW_SeqNo ];

/// 系统最后更新日期
Property PHWLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PHW_LastUpdateDate ];

/// 系统最后更新时间
Property PHWLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PHW_LastUpdateTime ];

/// 系统最新更新人
Property PHWLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PHW_LastUpdateUser ];

/// 拼音码
Property PHWPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PHW_PYCode ];

/// 五笔码
Property PHWWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PHW_WBCode ];

/// 备注
Property PHWMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PHW_Mark ];

/// 索引-岗位中心词代码
Index IndexPHWCode On PHWCode;

/// 索引-岗位中心词名称
Index IndexPHWDesc On PHWDesc;

/// 索引-业务域编码
Index IndexDomainCode On PHWDomainCode;

Storage Default
{
<Data name="HOSPostHeadWordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PHWCode</Value>
</Value>
<Value name="3">
<Value>PHWDesc</Value>
</Value>
<Value name="4">
<Value>PHWDomainCode</Value>
</Value>
<Value name="5">
<Value>PHWActivity</Value>
</Value>
<Value name="6">
<Value>PHWStartDate</Value>
</Value>
<Value name="7">
<Value>PHWEndDate</Value>
</Value>
<Value name="8">
<Value>PHWCreateDate</Value>
</Value>
<Value name="9">
<Value>PHWCreateTime</Value>
</Value>
<Value name="10">
<Value>PHWCreateUser</Value>
</Value>
<Value name="11">
<Value>PHWSeqNo</Value>
</Value>
<Value name="12">
<Value>PHWLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>PHWLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>PHWLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>PHWPYCode</Value>
</Value>
<Value name="16">
<Value>PHWWBCode</Value>
</Value>
<Value name="17">
<Value>PHWMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPostHeadWordD</DataLocation>
<DefaultData>HOSPostHeadWordDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPostHeadWordD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPostHeadWordI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPostHeadWordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
