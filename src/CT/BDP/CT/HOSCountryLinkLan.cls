/// 描述:国家关联语言字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-10-09
Class CT.BDP.CT.HOSCountryLinkLan Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_CountryLinkLan ]
{

/// 国家-外键
Property CLLCountryCode As User.CTCountry [ Required, SqlColumnNumber = 2, SqlFieldName = CLL_Country_Code ];

/// 语言-外键
Property CLLLANCode As User.SSLanguage [ Required, SqlColumnNumber = 3, SqlFieldName = CLL_LAN_Code ];

/// 是否有效(Y/N)
Property CLLActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = CLL_Activity ];

/// 开始日期
Property CLLStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = CLL_StartDate ];

/// 结束日期
Property CLLEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CLL_EndDate ];

/// 系统创建日期
Property CLLCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = CLL_CreateDate ];

/// 系统创建时间
Property CLLCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = CLL_CreateTime ];

/// 系统创建人
Property CLLCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CLL_CreateUser ];

/// 系统排序号
Property CLLSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = CLL_SeqNo ];

/// 系统最后更新日期
Property CLLLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CLL_LastUpdateDate ];

/// 系统最后更新时间
Property CLLLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CLL_LastUpdateTime ];

/// 系统最新更新人
Property CLLLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = CLL_LastUpdateUser ];

/// 拼音码
Property CLLPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CLL_PYCode ];

/// 五笔码
Property CLLWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CLL_WBCode ];

/// 备注
Property CLLMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CLL_Mark ];

/// 是否默认(Y/N)
Property CLLIsDefault As %String [ InitialExpression = "Y", SqlColumnNumber = 17, SqlFieldName = CLLI_sDefault ];

/// 索引-国家+语言外键
Index IndexCountryLAN On (CLLCountryCode, CLLLANCode);

/// 索引-语言+国家外键
Index IndexLANCountry On (CLLLANCode, CLLCountryCode);

/// 索引-国家-外键
Index IndexCountryCode On CLLCountryCode;

/// 索引-语言-外键
Index IndexLANCode On CLLLANCode;

/// 索引-系统排序号
Index IndexSeqNo On CLLSeqNo;

Storage Default
{
<Data name="HOSCountryLinkLanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLLCountryCode</Value>
</Value>
<Value name="3">
<Value>CLLLANCode</Value>
</Value>
<Value name="4">
<Value>CLLActivity</Value>
</Value>
<Value name="5">
<Value>CLLStartDate</Value>
</Value>
<Value name="6">
<Value>CLLEndDate</Value>
</Value>
<Value name="7">
<Value>CLLCreateDate</Value>
</Value>
<Value name="8">
<Value>CLLCreateTime</Value>
</Value>
<Value name="9">
<Value>CLLCreateUser</Value>
</Value>
<Value name="10">
<Value>CLLSeqNo</Value>
</Value>
<Value name="11">
<Value>CLLLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>CLLLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>CLLLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>CLLPYCode</Value>
</Value>
<Value name="15">
<Value>CLLWBCode</Value>
</Value>
<Value name="16">
<Value>CLLMark</Value>
</Value>
<Value name="17">
<Value>CLLIsDefault</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSCountryLinkLanD</DataLocation>
<DefaultData>HOSCountryLinkLanDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSCountryLinkLanD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSCountryLinkLanI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSCountryLinkLanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
