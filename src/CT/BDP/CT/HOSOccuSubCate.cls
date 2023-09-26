/// 描述:职业子类字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-21
Class CT.BDP.CT.HOSOccuSubCate Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OccuSubCate ]
{

/// 职业子类代码
Property OCCUSCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OCCUSC_Code ];

/// 职业子类名称
Property OCCUSCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OCCUSC_Desc ];

/// 职业大类-外键
Property OCCUSCOCCUCCode As CT.BDP.CT.HOSOccuCategory [ SqlColumnNumber = 4, SqlFieldName = OCCUSC_OCCUCCode ];

/// 是否有效(Y/N)
Property OCCUSCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = OCCUSC_Activity ];

/// 开始日期
Property OCCUSCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = OCCUSC_StartDate ];

/// 结束日期
Property OCCUSCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OCCUSC_EndDate ];

/// 系统创建日期
Property OCCUSCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = OCCUSC_CreateDate ];

/// 系统创建时间
Property OCCUSCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = OCCUSC_CreateTime ];

/// 系统创建人
Property OCCUSCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = OCCUSC_CreateUser ];

/// 系统排序号
Property OCCUSCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = OCCUSC_SeqNo ];

/// 系统最后更新日期
Property OCCUSCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = OCCUSC_LastUpdateDate ];

/// 系统最后更新时间
Property OCCUSCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OCCUSC_LastUpdateTime ];

/// 系统最新更新人
Property OCCUSCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OCCUSC_LastUpdateUser ];

/// 拼音码
Property OCCUSCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OCCUSC_PYCode ];

/// 五笔码
Property OCCUSCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OCCUSC_WBCode ];

/// 备注
Property OCCUSCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OCCUSC_Mark ];

/// 索引-代码
Index IndexCode On OCCUSCCode [ Unique ];

/// 索引-名称
Index IndexDesc On OCCUSCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On OCCUSCSeqNo;

/// 索引-职业大类-外键
Index IndexCategory On OCCUSCOCCUCCode;

Storage Default
{
<Data name="HOSOccuSubCateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OCCUSCCode</Value>
</Value>
<Value name="3">
<Value>OCCUSCDesc</Value>
</Value>
<Value name="4">
<Value>OCCUSCOCCUCCode</Value>
</Value>
<Value name="5">
<Value>OCCUSCActivity</Value>
</Value>
<Value name="6">
<Value>OCCUSCStartDate</Value>
</Value>
<Value name="7">
<Value>OCCUSCEndDate</Value>
</Value>
<Value name="8">
<Value>OCCUSCCreateDate</Value>
</Value>
<Value name="9">
<Value>OCCUSCCreateTime</Value>
</Value>
<Value name="10">
<Value>OCCUSCCreateUser</Value>
</Value>
<Value name="11">
<Value>OCCUSCSeqNo</Value>
</Value>
<Value name="12">
<Value>OCCUSCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>OCCUSCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>OCCUSCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>OCCUSCPYCode</Value>
</Value>
<Value name="16">
<Value>OCCUSCWBCode</Value>
</Value>
<Value name="17">
<Value>OCCUSCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOccuSubCateD</DataLocation>
<DefaultData>HOSOccuSubCateDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOccuSubCateD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOccuSubCateI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOccuSubCateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
